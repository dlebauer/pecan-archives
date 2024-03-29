!############################# Change Log ##################################
! 2.0.0
!
!###########################################################################
!  Copyright (C)  1990, 1995, 1999, 2000, 2003 - All Rights Reserved
!  Regional Atmospheric Modeling System - RAMS
!###########################################################################

integer function lastchar(str)
implicit none
character(len=*) :: str
integer :: n,ln
! returns last non-blank character position from a string

ln=len(str)
do n=ln,1,-1
   if(str(n:n).ne.' ') then
      lastchar=n
      return
   endif
enddo
lastchar=0

return
end

!***************************************************************************

integer function ifirstchar(str)
implicit none
character(len=*) :: str
integer :: n,ln

! returns first non-blank character position from a string

ln=len(str)
do n=1,ln
   if(str(n:n).ne.' ') then
      ifirstchar=n
      return
   endif
enddo
ifirstchar=1

return
end

!***************************************************************************

subroutine deblank(str1,str2,nch)
implicit none
character(len=*) :: str1,str2
integer :: n,ln,nch

! strips blanks from a string and returns number of chars

str2=' '
ln=len(str1)
nch=0
do n=1,ln
   if(str1(n:n).ne.' ') then
      nch=nch+1
      str2(nch:nch)=str1(n:n)
   endif
enddo

return
end

!***************************************************************************

subroutine detab(str1,str2,nch)
implicit none
character(len=*) :: str1,str2
integer :: n,ln,nch
character(len=1) ::  tab

tab=achar( 9)

! strips tabs from a string and returns number of chars

str2=' '
ln=len_trim(str1)
nch=0
do n=1,ln
   if(str1(n:n).ne.tab) then
      !print*,'no tab:',str1(n:n)
      nch=nch+1
      str2(nch:nch)=str1(n:n)
   else
      print*,'found one:',str1
      str2(nch+1:nch+6)='      '
      nch=nch+6
   endif
enddo

return
end

!***************************************************************************

integer function lastslash(str)
implicit none
character(len=*) :: str
integer :: n,ln

! returns last slash character position from a string

ln=len(str)
do n=ln,1,-1
   if(str(n:n).eq.'/') then
      lastslash=n
      return
   endif
enddo
lastslash=0

return
end

!***************************************************************************

subroutine char_strip_var(line,var,line2)
implicit none
character(len=*) :: line,var,line2
integer :: nn,ncl,nb

! removes instances of a substring from a string

ncl=len(line)
do nn=1,ncl
   if(line(nn:nn).ne.' ') then
      nb=index(line(nn:),' ')
      var=line(nn:nn+nb-1)
      goto 25
   endif
enddo
25 continue
line2=line(nn+nb-1:)

return
end

!***************************************************************************

subroutine findln(text,ltext,order)
implicit none
character(len=*) :: text
integer :: ltext,order
integer :: i

! find first non-blank character if order=0, last non-blank if order=1

if(order.eq.1) then
   do i=len(text),1,-1
      if(text(i:i).ne.' ') then
         ltext=i
         goto 10
      endif
   enddo
   10 continue
else
   do i=1,len(text)
      if(text(i:i).ne.' ') then
         ltext=i
         goto 20
      endif
   enddo
   20 continue
endif

return
end

!***************************************************************************

subroutine parse(str,tokens,ntok)
implicit none
integer :: ntok
character(len=*) :: str,tokens(*)
character(len=1) :: sep
integer, parameter :: ntokmax=100

integer :: n,nc,npt,nch,ntbeg,ntend

! this routine "parses" character string str into different pieces
! or tokens by looking for  possible token separators (toks
! str contains nch characters.  the number of tokens identified is nto
! the character string tokens are stored in tokens.

sep=' '
ntok=0
npt=1
nch=len_trim(str)
nc=1
do ntok=1,ntokmax
   do n=nc,nch
      if(str(n:n).ne.sep) then
         ntbeg=n
         goto 21
      endif
   enddo
   21 continue
   do n=ntbeg,nch
      if(str(n:n).eq.sep) then
         ntend=n-1
         goto 22
      endif
      if(n.eq.nch) then
         ntend=n
         goto 22
      endif
   enddo
   22 continue
   tokens(ntok)=str(ntbeg:ntend)
   nc=ntend+1
   if(nc.ge.nch) goto 25
enddo

25 continue

!do nc=1,nch
!   if(str(nc:nc).eq.sep.or.nc.eq.nch)then
!      if(nc-npt.ge.1)then
!         ntok=ntok+1
!         tokens(ntok)=str(npt:nc-1)
!         if(nc.eq.nch.and.str(nc:nc).ne.sep)then
!            tokens(ntok)=str(npt:nc)
!            go to 10
!         endif
!      endif
!      ntok=ntok+1
!      tokens(ntok)=str(nc:nc)
!      npt=nc+1
!      go to 10
!   endif
!   10 continue
!enddo

return
end

!***************************************************************************

subroutine tokenize(str1,tokens,ntok,toksep,nsep)
implicit none
integer :: nsep,ntok
character(len=*) :: str1,tokens(*)
character(len=1) :: toksep(nsep)

character(len=256) :: str
integer :: npt,nch,nc,ns

! this routine "parses" character string str into different pieces
! or tokens by looking for  possible token separators (toks
! str contains nch characters.  the number of tokens identified is nto
! the character string tokens are stored in tokens.

ntok=0
npt=1
call deblank(str1,str,nch)
do nc=1,nch
   do ns=1,nsep
      if(str(nc:nc).eq.toksep(ns).or.nc.eq.nch) then
         if(nc-npt.ge.1)then
            ntok=ntok+1
            tokens(ntok)=str(npt:nc-1)
            if(nc.eq.nch.and.str(nc:nc).ne.toksep(ns)) then
               tokens(ntok)=str(npt:nc)
               goto 10
            endif
         endif
         ntok=ntok+1
         tokens(ntok)=str(nc:nc)
         npt=nc+1
         goto 10
      endif
   enddo
10      continue
enddo
return
end

!***************************************************************************

subroutine tokenize1(str1,tokens,ntok,toksep)
implicit none
integer :: ntok
character(len=*) :: str1,tokens(*)
character(len=1), intent(in) :: toksep

character(len=256) :: str
integer :: nch,ist,npt,nc

! this routine "parses" character string str into different pieces
! or tokens by looking for  possible token separators (toks
! str contains nch characters.  the number of tokens identified is nto
! the character string tokens are stored in tokens.

call deblank(str1,str,nch)

ist=1
if(str(1:1).eq.toksep) ist=2
npt=ist
ntok=0
do nc=ist,nch
   if(str(nc:nc).eq.toksep.or.nc.eq.nch) then
      if(nc-npt.ge.1) then
         ntok=ntok+1
         tokens(ntok)=str(npt:nc-1)
         if(nc.eq.nch.and.str(nc:nc).ne.toksep) then
            tokens(ntok)=str(npt:nc)
            goto 10
         endif
         npt=nc+1
      endif
   endif
enddo
10 continue

return
end

!***************************************************************************

subroutine tokfind(toks,ntok,str,iff)
implicit none
integer :: ntok,iff
character(len=*) :: toks(*),str

integer :: n

! looks for a number of tokens (substrings) within a string

do n=1,ntok
   !print*,'tokfind-',n,toks(n)(1:lastchar(toks(n)))  &
   !      ,'=====',str(1:lastchar(str))
   if(trim(str) == trim(toks(n))) then
      iff=1
      return
   endif
enddo
iff=0

return
end

!***************************************************************************

subroutine rams_intsort(ni,nums,cstr)
implicit none
integer :: nums(*),ni
character(len=*) :: cstr(*)

character(len=200) :: cscr
integer :: n,mini,nm,nmm,nscr

! sort an array of character strings by an associated integer field

do n=1,ni
   mini=1000000
   do nm=n,ni
      if(nums(nm).lt.mini) then
         nmm=nm
         mini=nums(nm)
      endif
   enddo
   nscr=nums(n)
   nums(n)=nums(nmm)
   nums(nmm)=nscr
   cscr=cstr(n)
   cstr(n)=cstr(nmm)
   cstr(nmm)=cscr
enddo

return
end

!***************************************************************************

subroutine rams_fltsort(ni,xnums,cstr)
implicit none
integer :: ni
real :: xnums(*)
character(len=*) :: cstr(*)

character(len=200) :: cscr
integer :: n,nm,nmm
real :: xmini,xnscr

! sort an array of character strings by an associated float field

do n=1,ni
   xmini=1.e30
   do nm=n,ni
      if(xnums(nm).lt.xmini) then
         nmm=nm
         xmini=xnums(nm)
      endif
   enddo
   xnscr=xnums(n)
   xnums(n)=xnums(nmm)
   xnums(nmm)=xnscr
   cscr=cstr(n)
   cstr(n)=cstr(nmm)
   cstr(nmm)=cscr
enddo

return
end
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine tolower(word,dimword)
!------------------------------------------------------------------------------------------!
! Subroutine tolower                                                                       !
!                                                                                          !
!    This subroutine converts all common upper-case characters into lowercase.             !
!------------------------------------------------------------------------------------------!
  implicit none
!----- Arguments --------------------------------------------------------------------------!
  integer, intent(in)                                 :: dimword
  character(len=*), dimension(dimword), intent(inout) :: word
!----- Internal variables -----------------------------------------------------------------!
  integer                                       :: wmax,w,d
!------------------------------------------------------------------------------------------!
  do d=1,dimword
    wmax=len_trim(word(d))
    do w=1,wmax
      select case(word(d)(w:w))
      case('A') 
        word(d)(w:w)='a'
      case('B')
        word(d)(w:w)='b'
      case('C')
        word(d)(w:w)='c'
      case('D')
        word(d)(w:w)='d'
      case('E')
        word(d)(w:w)='e'
      case('F')
        word(d)(w:w)='f'
      case('G')
        word(d)(w:w)='g'
      case('H')
        word(d)(w:w)='h'
      case('I')
        word(d)(w:w)='i'
      case('J')
        word(d)(w:w)='j'
      case('K')
        word(d)(w:w)='k'
      case('L')
        word(d)(w:w)='l'
      case('M')
        word(d)(w:w)='m'
      case('N')
        word(d)(w:w)='n'
      case('O')
        word(d)(w:w)='o'
      case('P')
        word(d)(w:w)='p'
      case('Q')
        word(d)(w:w)='q'
      case('R')
        word(d)(w:w)='r'
      case('S')
        word(d)(w:w)='s'
      case('T')
        word(d)(w:w)='t'
      case('U')
        word(d)(w:w)='u'
      case('V')
        word(d)(w:w)='v'
      case('W')
        word(d)(w:w)='w'
      case('X')
        word(d)(w:w)='x'
      case('Y')
        word(d)(w:w)='y'
      case('Z')
        word(d)(w:w)='z'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      case('�')
        word(d)(w:w)='�'
      end select
    end do
  end do
  return
end subroutine tolower
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!   These subroutines were in dateutils, but they fit better in this file...               !
!------------------------------------------------------------------------------------------!
subroutine RAMS_dintsort(ni,chnums,cstr)
   implicit none
   integer :: ni
   character(len=14) :: chnums(*)
   character(len=*) :: cstr(*)

   ! sort an array of character strings by an associated character field

   character(len=200) :: cscr
   character(len=14) :: mini,nscr

   integer :: n,nm,nmm

   do n=1,ni
      mini='99999999999999'
      do nm=n,ni
         if(chnums(nm).lt.mini) then
            nmm=nm
            mini=chnums(nm)
         endif
      enddo
      nscr=chnums(n)
      chnums(n)=chnums(nmm)
      chnums(nmm)=nscr
      cscr=cstr(n)
      cstr(n)=cstr(nmm)
      cstr(nmm)=cscr
   enddo

   return
end subroutine RAMS_dintsort
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine RAMS_sort_dint3 (n1,ia1,n2,ia2,n3,ia3,nt,iall)
   implicit none
   integer :: n1,n2,n3,nt
   character(len=14) :: ia1(*),ia2(*),ia3(*),iall(*)

   !     sort 3 arrays of char's, put back in 1 array
   !     copy all to output array

   character(len=14) :: mini,nscr
   integer :: n,nm,nmm

   nt=0
   do n=1,n1
      nt=nt+1
      iall(nt)=ia1(n)
   enddo
   do n=1,n2
      nt=nt+1
      iall(nt)=ia2(n)
   enddo
   do n=1,n3
      nt=nt+1
      iall(nt)=ia3(n)
   enddo

   do n=1,nt
      mini='99999999999999'
      do nm=n,nt
         if(iall(nm).lt.mini) then
            nmm=nm
            mini=iall(nm)
         endif
      enddo
      nscr=iall(n)
      iall(n)=iall(nmm)
      iall(nmm)=nscr
   enddo

   return
end subroutine RAMS_sort_dint3
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine RAMS_unique_dint (n1,ia1)
   implicit none
   integer :: n1
   character(len=14) :: ia1(*)

   integer :: n,nt,nn

   ! reduce an array to get rid of duplicate entries


   nt=n1
   10 continue
   do n=2,nt
      if(ia1(n).eq.ia1(n-1)) then
         do nn=n,nt
            ia1(nn-1)=ia1(nn)
         enddo
         nt=nt-1
         goto 10
      endif
   enddo
   n1=nt

   return
end subroutine RAMS_unique_dint
!==========================================================================================!
!==========================================================================================!
