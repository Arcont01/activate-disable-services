#!/bin/bash
while :
  do clear; if [ -f activo.txt ]; then $(rm activo.txt ); fi; if [ -f inactivo.txt ]; then $(rm inactivo.txt ); fi
  echo -e "Escoja una opcion \n" $(tput setaf 2) "1. Activar Servicios \n" $(tput setaf 1) "2. Desactivar Servicios \n" $(tput sgr0) "3. Salir \n"
  echo -n "Seleccione una opcion [1 - 3]"
  read opc; case $opc in
  1)
  while : ; do
    if [ -f inactivo.txt ]; then $(rm inactivo.txt ); fi; clear; echo "Servicios Desactivados:"
    $(systemctl list-unit-files --type=service --state=disabled > inactivo.txt && sed -i 1d inactivo.txt && sed -i '/^$/, $d' inactivo.txt && sed -i 's/ .*$//' inactivo.txt)
    echo $(tput setaf 1); $(echo -n nl inactivo.txt ); echo $(tput sgr0)
    echo -n "Seleccione el servicio que quiere activar o presione [0] si quiere salir: "; read servicio
    case $servicio in
      0) break;;
      *) count=1; while read line; do if [ $servicio == $count ]; then $(sudo systemctl enable $line); break; fi; ((count++)); done < inactivo.txt;;
    esac
  done;;
  2)
  while : ; do
    if [ -f activo.txt ]; then $(rm activo.txt ); fi; clear; echo "Servicios Activos:"
    $(systemctl list-unit-files --type=service --state=enabled > activo.txt && sed -i 1d activo.txt && sed -i '/^$/, $d' activo.txt && sed -i 's/ .*$//' activo.txt)
    echo $(tput setaf 2); $(echo nl activo.txt); echo $(tput sgr0)
    echo -n "Seleccione el servicio que quiere desactivar o presione [0] si quiere salir: "; read servicio
    case $servicio in
      0) break;;
      *) count=1; while read line; do if [ $servicio == $count ]; then $(sudo systemctl disable $line); break; fi; ((count++)); done < activo.txt;;
    esac
  done;;
  3) clear; exit 1;;
  *) echo "$opc no es una opcion válida."; read -p "Presiona [Enter] para continuar..."; clear;;
  esac
done
