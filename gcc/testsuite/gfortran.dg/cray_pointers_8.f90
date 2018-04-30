! { dg-do run }
! { dg-options "-fcray-pointer -ffloat-store" }
!
! Test the fix for PR36528 in which the Cray pointer was not passed
! correctly to 'euler' so that an undefined reference to fcn was
! generated by the linker.
!
! Reported by Tobias Burnus  <burnus@gcc.gnu.org>
! from http://groups.google.com/group/comp.lang.fortran/msg/86b65bad78e6af78
!
real function p1(x)
  real, intent(in) :: x
  p1 = x
end

real function euler(xp,xk,dx,f)
  real, intent(in) :: xp, xk, dx
  interface
    real function f(x)
      real, intent(in) :: x
    end function
  end interface
  real x, y
  y = 0.0
  x = xp
  do while (x .le. xk)
    y = y + f(x)*dx
    x = x + dx
  end do
  euler = y
end
program main
  interface
    real function p1 (x)
      real, intent(in) :: x
    end function
    real function fcn (x)
      real, intent(in) :: x
    end function
    real function euler (xp,xk,dx,f)
      real, intent(in) :: xp, xk ,dx
      interface
        real function f(x)
          real, intent(in) :: x
        end function
      end interface
    end function
  end interface
  real x, xp, xk, dx, y, z
  pointer (pfcn, fcn)
  pfcn = loc(p1)
  xp = 0.0
  xk = 1.0
  dx = 0.0005
  y = 0.0
  x = xp
  do while (x .le. xk)
    y = y + fcn(x)*dx
    x = x + dx
  end do
  z = euler(0.0,1.0,0.0005,fcn)
  if (abs (y - z) .gt. 1e-6) STOP 1
end
