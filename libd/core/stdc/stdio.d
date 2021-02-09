/**
 * D header file for C99 <stdio.h>
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_stdio.h.html, _stdio.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly,
 *            Alex Rønne Petersen
 * Source:    https://github.com/dlang/druntime/blob/master/src/core/stdc/stdio.d
 * Standards: ISO/IEC 9899:1999 (E)
 */

module core.stdc.stdio;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

private
{
    import core.stdc.stdarg; // for va_list
    import core.stdc.stdint : intptr_t;

  version (FreeBSD)
  {
    import core.sys.posix.sys.types;
  }
  else version (OpenBSD)
  {
    import core.sys.posix.sys.types;
  }
  version (NetBSD)
  {
    import core.sys.posix.sys.types;
  }
  version (DragonFlyBSD)
  {
    import core.sys.posix.sys.types;
  }
}

extern (C):
@system:
nothrow:
@nogc:

enum
{
    /// Offset is relative to the beginning
    SEEK_SET,
    /// Offset is relative to the current position
    SEEK_CUR,
    /// Offset is relative to the end
    SEEK_END
}

enum
{
    ///
    _F_RDWR = 0x0003, // non-standard
    ///
    _F_READ = 0x0001, // non-standard
    ///
    _F_WRIT = 0x0002, // non-standard
    ///
    _F_BUF  = 0x0004, // non-standard
    ///
    _F_LBUF = 0x0008, // non-standard
    ///
    _F_ERR  = 0x0010, // non-standard
    ///
    _F_EOF  = 0x0020, // non-standard
    ///
    _F_BIN  = 0x0040, // non-standard
    ///
    _F_IN   = 0x0080, // non-standard
    ///
    _F_OUT  = 0x0100, // non-standard
    ///
    _F_TERM = 0x0200, // non-standard
}

///
int sprintf(scope char* s, scope const char* format, ...);
///
int sscanf(scope const char* s, scope const char* format, ...);
///
int vsprintf(scope char* s, scope const char* format, va_list arg);
///
int vsscanf(scope const char* s, scope const char* format, va_list arg);
///
int vprintf(scope const char* format, va_list arg);
///
int vscanf(scope const char* format, va_list arg);
///
int printf(scope const char* format, ...);
///
int scanf(scope const char* format, ...);

///
char* gets(char* s);
///
int   puts(scope const char* s);

///
int snprintf(scope char* s, size_t n, scope const char* format, ...);
///
int vsnprintf(scope char* s, size_t n, scope const char* format, va_list arg);

///
void perror(scope const char* s);

version (CRuntime_DigitalMars)
{
    version (none)
        import core.sys.windows.windows : HANDLE, _WaitSemaphore, _ReleaseSemaphore;
    else
    {
        // too slow to import windows
        private alias void* HANDLE;
        private void _WaitSemaphore(int iSemaphore);
        private void _ReleaseSemaphore(int iSemaphore);
    }

    enum
    {
        ///
        FHND_APPEND     = 0x04,
        ///
        FHND_DEVICE     = 0x08,
        ///
        FHND_TEXT       = 0x10,
        ///
        FHND_BYTE       = 0x20,
        ///
        FHND_WCHAR      = 0x40,
    }

    private enum _MAX_SEMAPHORES = 10 + _NFILE;
    private enum _semIO = 3;

    private extern __gshared short[_MAX_SEMAPHORES] _iSemLockCtrs;
    private extern __gshared int[_MAX_SEMAPHORES] _iSemThreadIds;
    private extern __gshared int[_MAX_SEMAPHORES] _iSemNestCount;
    private extern __gshared HANDLE[_NFILE] _osfhnd;
    extern shared ubyte[_NFILE] __fhnd_info;

    // this is copied from semlock.h in DMC's runtime.
    private void LockSemaphore()(uint num)
    {
        asm nothrow @nogc
        {
            mov EDX, num;
            lock;
            inc _iSemLockCtrs[EDX * 2];
            jz lsDone;
            push EDX;
            call _WaitSemaphore;
            add ESP, 4;
        }

    lsDone: {}
    }

    // this is copied from semlock.h in DMC's runtime.
    private void UnlockSemaphore()(uint num)
    {
        asm nothrow @nogc
        {
            mov EDX, num;
            lock;
            dec _iSemLockCtrs[EDX * 2];
            js usDone;
            push EDX;
            call _ReleaseSemaphore;
            add ESP, 4;
        }

    usDone: {}
    }

    // This converts a HANDLE to a file descriptor in DMC's runtime
    ///
    int _handleToFD()(HANDLE h, int flags)
    {
        LockSemaphore(_semIO);
        scope(exit) UnlockSemaphore(_semIO);

        foreach (fd; 0 .. _NFILE)
        {
            if (!_osfhnd[fd])
            {
                _osfhnd[fd] = h;
                __fhnd_info[fd] = cast(ubyte)flags;
                return fd;
            }
        }

        return -1;
    }

    ///
    HANDLE _fdToHandle()(int fd)
    {
        // no semaphore is required, once inserted, a file descriptor
        // doesn't change.
        if (fd < 0 || fd >= _NFILE)
            return null;

        return _osfhnd[fd];
    }

    enum
    {
        ///
        STDIN_FILENO  = 0,
        ///
        STDOUT_FILENO = 1,
        ///
        STDERR_FILENO = 2,
    }

    int open(scope const(char)* filename, int flags, ...); ///
    alias _open = open; ///
    int _wopen(scope const wchar* filename, int oflag, ...); ///
    int sopen(scope const char* filename, int oflag, int shflag, ...); ///
    alias _sopen = sopen; ///
    int _wsopen(scope const wchar* filename, int oflag, int shflag, ...); ///
    int close(int fd); ///
    alias _close = close; ///
    FILE *fdopen(int fd, scope const(char)* flags); ///
    alias _fdopen = fdopen; ///
    FILE *_wfdopen(int fd, scope const(wchar)* flags); ///

}
else version (CRuntime_Microsoft)
{
    int _open(scope const char* filename, int oflag, ...); ///
    int _wopen(scope const wchar* filename, int oflag, ...); ///
    int _sopen(scope const char* filename, int oflag, int shflag, ...); ///
    int _wsopen(scope const wchar* filename, int oflag, int shflag, ...); ///
    int _close(int fd); ///
    FILE *_fdopen(int fd, scope const(char)* flags); ///
    FILE *_wfdopen(int fd, scope const(wchar)* flags); ///
}

version (Windows)
{
    // file open flags
    enum
    {
        _O_RDONLY = 0x0000, ///
        O_RDONLY = _O_RDONLY, ///
        _O_WRONLY = 0x0001, ///
        O_WRONLY = _O_WRONLY, ///
        _O_RDWR   = 0x0002, ///
        O_RDWR = _O_RDWR, ///
        _O_APPEND = 0x0008, ///
        O_APPEND = _O_APPEND, ///
        _O_CREAT  = 0x0100, ///
        O_CREAT = _O_CREAT, ///
        _O_TRUNC  = 0x0200, ///
        O_TRUNC = _O_TRUNC, ///
        _O_EXCL   = 0x0400, ///
        O_EXCL = _O_EXCL, ///
        _O_TEXT   = 0x4000, ///
        O_TEXT = _O_TEXT, ///
        _O_BINARY = 0x8000, ///
        O_BINARY = _O_BINARY, ///
    }

    enum
    {
        _S_IREAD  = 0x0100, /// read permission, owner
        S_IREAD = _S_IREAD, /// read permission, owner
        _S_IWRITE = 0x0080, /// write permission, owner
        S_IWRITE = _S_IWRITE, /// write permission, owner
    }

    enum
    {
        _SH_DENYRW = 0x10, /// deny read/write mode
        SH_DENYRW = _SH_DENYRW, /// deny read/write mode
        _SH_DENYWR = 0x20, /// deny write mode
        SH_DENYWR = _SH_DENYWR, /// deny write mode
        _SH_DENYRD = 0x30, /// deny read mode
        SH_DENYRD = _SH_DENYRD, /// deny read mode
        _SH_DENYNO = 0x40, /// deny none mode
        SH_DENYNO = _SH_DENYNO, /// deny none mode
    }
}
