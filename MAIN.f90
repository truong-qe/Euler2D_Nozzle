!  Free-Format Fortran Source File  
!  Generated by PGI Visual Fortran(R) 
!  06/28/2010 18:52:57 
! 
!######################################################################! 
!   This code is for the CFD course. The mesh generation module, the   ! 
!   time-marching processing module, and the post-processing module    ! 
!   are available in this code. Students need to work out the module   ! 
!   which evaluates the numerical advective flux.                      ! 
!   The flow case to be calculated is GAMM flow, for which with        ! 
!   different specified back pressure the flow could be subsonic or    ! 
!   supersonic with several oblique shock waves.                       ! 
!######################################################################! 
! 
! 
!========================== Main program begin ========================= 
      PROGRAM MAIN 
      USE MODGLOB 
      IMPLICIT REAL*8(A-H,O-Z) 
! 
!---Define the dimension of the computational mesh: 
      IN = 201     !---Along the flow direction. 
      JN = 81      !---On the normal direction. 
! 
      WRITE(*,*) 'the type of inflow' 
      WRITE(*,*) '1=supersonic,2=subsonic' 
      READ(*,*) NTASK 
! 
!---Define the B.C. at inlet: 
      SPINL = 50000.0 
      DNINL = 1.22 
      IF(NTASK==1) THEN 
        VMINL = 1.4D0 
      ELSE 
        VMINL = 0.6D0 
      END IF 
! 
!---Define the B.C. at outlet: 
      SPOUT = 50000.0 
! 
!---Define the CFL number: 
      CFL = 0.1D0 
! 
!---Define the maximum time-marching loops: 
      NPASSM = 50000 
! 
      ALLOCATE( X(IN,JN), Y(IN,JN) ) 
      ALLOCATE( XLNI(IN,JN-1), YLNI(IN,JN-1), SLNI(IN,JN-1),& 
                XLNJ(IN-1,JN), YLNJ(IN-1,JN), SLNJ(IN-1,JN), SARC(IN-1,JN-1) ) 
      ALLOCATE( DENS(-1:IN+1,-1:JN+1), VELX(-1:IN+1,-1:JN+1), VELY(-1:IN+1,-1:JN+1),& 
                PRES(-1:IN+1,-1:JN+1), FLUX(4,IN-1,JN-1) ) 
! 
      RGAS  = 287.06D0 
      GAMA  = 1.4D0 
      GAMAM = GAMA - 1.D0 
      GAMSM = GAMA/GAMAM 
      GAMMH = GAMAM/2.D0 
! 
      !CALL GENMESH 
	  CALL READMESH
      CALL INIFLOW 
! 
      DO NPASS=1,NPASSM 
        CALL DEFBCON 
        CALL RESIDUAL 
        CALL UPDATEQ 
		IF (MOD(NPASS,1000).EQ.0) CALL POSTOUT(NPASS)
      END DO       
! 
      STOP 
      END 
!============================ End of MAIN ============================== 



