  !< Writing solution in the output file in tecplot format with
  !< node data instead of cell-center data.
module write_output_tec_node
  !< Writing solution in the output file in tecplot format with
  !< node data instead of cell-center data.
  !---------------------------------------------------------
  ! This module write state + other variable in output file
  !---------------------------------------------------------
  use global     , only : OUT_FILE_UNIT
  use global     , only : OUTIN_FILE_UNIT
  use global     , only : outin_file

  use global_vars, only : write_data_format
  use global_vars, only : write_file_format
  use global_vars, only : imx
  use global_vars, only : jmx
  use global_vars, only : kmx
  use global_vars, only : grid_x
  use global_vars, only : grid_y
  use global_vars, only : grid_z
  use global_vars, only : density 
  use global_vars, only : x_speed 
  use global_vars, only : y_speed 
  use global_vars, only : z_speed 
  use global_vars, only : pressure 
  use global_vars, only : tk 
  use global_vars, only : tw 
  use global_vars, only : tkl
  use global_vars, only : tv
  use global_vars, only : mu 
  use global_vars, only : mu_t 
  use global_vars, only : density_inf
  use global_vars, only : x_speed_inf
  use global_vars, only : y_speed_inf
  use global_vars, only : z_speed_inf
  use global_vars, only : pressure_inf 
  use global_vars, only : gm
  use global_vars, only : dist
  use global_vars, only : vis_resnorm
  use global_vars, only : cont_resnorm
  use global_vars, only : x_mom_resnorm
  use global_vars, only : y_mom_resnorm
  use global_vars, only : z_mom_resnorm
  use global_vars, only : energy_resnorm
  use global_vars, only : resnorm
  use global_vars, only :   mass_residue
  use global_vars, only :  x_mom_residue
  use global_vars, only :  y_mom_residue
  use global_vars, only :  z_mom_residue
  use global_vars, only : energy_residue
  use global_vars, only : TKE_residue
  use global_vars, only : intermittency

  use global_vars, only : turbulence
  use global_vars, only : mu_ref
  use global_vars, only : current_iter
  use global_vars, only : max_iters
  use global_vars, only : w_count
  use global_vars, only : w_list

  use global_sst , only : sst_F1
  use global_vars, only : gradu_x
  use global_vars, only : gradu_y
  use global_vars, only : gradu_z
  use global_vars, only : gradv_x
  use global_vars, only : gradv_y
  use global_vars, only : gradv_z
  use global_vars, only : gradw_x
  use global_vars, only : gradw_y
  use global_vars, only : gradw_z
  use global_vars, only : gradT_x
  use global_vars, only : gradT_y
  use global_vars, only : gradT_z
  use global_vars, only : gradtk_x
  use global_vars, only : gradtk_y
  use global_vars, only : gradtk_z
  use global_vars, only : gradtw_x
  use global_vars, only : gradtw_y
  use global_vars, only : gradtw_z
  use global_vars, only : process_id
  use global_vars, only : checkpoint_iter_count

  use utils
  use string

  implicit none
  private
  integer :: i,j,k
  real    :: speed_inf
  character(len=8) :: file_format
  character(len=16) :: data_format
  character                          :: newline=achar(10)
  character(len=*), parameter :: format="(35e25.15)"
  public :: write_file

  contains

    subroutine write_file()
      !< write output file in the tecplot format with node data
      implicit none
      integer :: n
      character(len=*), parameter :: err="Write error: Asked to write non-existing variable- "

      call write_header()
      call write_grid()

      do n = 1,w_count

        select case (trim(w_list(n)))
        
          case('Velocity')
            call write_scalar(x_speed, "u", -2)
            call write_scalar(y_speed, "v", -2)
            call write_scalar(z_speed, "w", -2)

          case('Density')
            call write_scalar(density, "Density", -2)
          
          case('Pressure')
            call write_scalar(pressure, "Pressure", -2)
            
          case('Mu')
            call write_scalar(mu, "Mu", -2)
            
          case('Mu_t')
            call write_scalar(mu_t, "Mu_t", -2)
            
          case('TKE')
            call write_scalar(tk, "TKE",  -2)

          case('Omega')
            call write_scalar(tw, "Omega", -2)

          case('Kl')
            call write_scalar(tkl, "Kl", -2)

          case('tv')
            call write_scalar(tv, "tv", -2)

         ! case('Wall_distance')
         !   call write_scalar(dist, "Wall_dist", 1)

          case('F1')
            call write_scalar(sst_F1, "F1",  -2)

          case('Dudx')
            call write_scalar(gradu_x ,"dudx ", 0)
                                               
          case('Dudy')                         
            call write_scalar(gradu_y ,"dudy ", 0)
                                               
          case('Dudz')                         
            call write_scalar(gradu_z ,"dudz ", 0)
                                               
          case('Dvdx')                         
            call write_scalar(gradv_x ,"dvdx ", 0)
                                               
          case('Dvdy')                         
            call write_scalar(gradv_y ,"dvdy ", 0)
                                               
          case('Dvdz')                         
            call write_scalar(gradv_z ,"dvdz ", 0)
                                               
          case('Dwdx')                         
            call write_scalar(gradw_x ,"dwdx ", 0)
                                               
          case('Dwdy')                         
            call write_scalar(gradw_y ,"dwdy ", 0)
                                               
          case('Dwdz')                         
            call write_scalar(gradw_z ,"dwdz ", 0)
                                               
          case('DTdx')                         
            call write_scalar(gradT_x ,"dTdx ", 0)
                                               
          case('DTdy')                         
            call write_scalar(gradT_y ,"dTdy ", 0)
                                               
          case('DTdz')                         
            call write_scalar(gradT_z ,"dTdz ", 0)
                                               
          case('Dtkdx')                        
            call write_scalar(gradtk_x,"dtkdx", 0)
                                               
          case('Dtkdy')                        
            call write_scalar(gradtk_y,"dtkdy", 0)
                                               
          case('Dtkdz')                        
            call write_scalar(gradtk_z,"dtkdz", 0)
                                               
          case('Dtwdx')                        
            call write_scalar(gradtw_x,"dtwdx", 0)
                                               
          case('Dtwdy')                        
            call write_scalar(gradtw_y,"dtwdy", 0)
                                               
          case('Dtwdz')                        
            call write_scalar(gradtw_z,"dtwdz", 0)

          case('Intermittency')
            call write_scalar(intermittency, "Intermittency", -2)
          
         ! case('Mass_residue')
         !   call write_scalar(mass_residue, "Mass_residue", 1)

         ! case('X_mom_residue')
         !   call write_scalar(x_mom_residue, "X_mom_residue", 1)

         ! case('Y_mom_residue')
         !   call write_scalar(y_mom_residue, "Y_mom_residue", 1)

         ! case('Z_mom_residue')
         !   call write_scalar(z_mom_residue, "Z_mom_residue", 1)

         ! case('Energy_residue')
         !   call write_scalar(energy_residue, "Energy_residue", 1)

          case('do not write')
            ! do not write
            continue

          case Default
            print*, err//trim(w_list(n))//" to file"

        end select
      end do


    end subroutine write_file


    subroutine write_header()
      !< write the header in the output file
      implicit none
      integer :: n
      integer :: total

      call dmsg(1, 'write_output_vtk', 'write_header')
      write(OUT_FILE_UNIT,'(a)') "variables = x y z "

      total=3
      do n = 1,w_count

        select case (trim(w_list(n)))
        
          case('Velocity')
            write(OUT_FILE_UNIT, '(a)') " u v w "
            total = total+3

          case('do not write')
            !skip 
            continue

          case Default
            write(OUT_FILE_UNIT, '(a)') trim(w_list(n))//" "
            total = total+1

        end select
      end do

      write(OUT_FILE_UNIT, '(a,i4.4,3(a,i5.5),a)') "zone T=block",process_id,"  i=",imx," j=",jmx, " k=",kmx-1, " Datapacking=Block"

      write(OUT_FILE_UNIT,*) "Varlocation=([1-3]=Nodal)"
      write(OUT_FILE_UNIT,'(a,i2.2,a)') "Varlocation=([4-",total,"]=Nodal)"
      write(OUT_FILE_UNIT,"(a,i4.4)") "STRANDID=",1
      write(OUT_FILE_UNIT,"(a,i4.4)") "SOLUTIONTIME=",checkpoint_iter_count


    end subroutine write_header

    subroutine write_grid()
      !< write grid information in the output file
      implicit none

      ! write grid point coordinates
      call dmsg(1, 'write_output_tec_node', 'write_grid')
      write(OUT_FILE_UNIT, format) (((grid_x(i, j, k),i=1,imx), j=1,jmx), k=1,kmx-1)
      write(OUT_FILE_UNIT, format) (((grid_y(i, j, k),i=1,imx), j=1,jmx), k=1,kmx-1)
      write(OUT_FILE_UNIT, format) (((grid_z(i, j, k),i=1,imx), j=1,jmx), k=1,kmx-1)

    end subroutine write_grid

    subroutine write_scalar(var, name, index)
      !< write scalar variable in the output file
      implicit none
      integer, intent(in) :: index
      real, dimension(index:imx-index,index:jmx-index,index:kmx-index), intent(in) :: var
      character(len=*),       intent(in):: name

      call dmsg(1, 'write_output_tec_node', trim(name))

      write(OUT_FILE_UNIT, format) (((0.25*(var(i, j, k) + var(i-1,j,k)&
                                          + var(i, j-1, k) + var(i-1,j-1,k))&
                                          ,i=1,imx), j=1,jmx), k=1,kmx-1)

    end subroutine write_scalar


end module write_output_tec_node
