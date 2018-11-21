#!/bin/sh
# This file is named contruct_geometry.sh
##---------------------------------------------------------------------------##
## ---------------------- Example Geometry Constructor ----------------------##
##---------------------------------------------------------------------------##
## This script can be used to construct the Trelis geometry.
## To construct a geometry run 'geom_constructor.sh' and then entered the
## the desired source energy.
##---------------------------------------------------------------------------##

temp_file=$(mktemp)

echo "Enter the desired source energy in MeV ( 0.001, 0.01, 0.1 ):"
read energy

if [ ${energy} = "0.1" ]; then
  echo "Constructing geometry for source energy 0.1 MeV!"
  radius="20.0"
  length1="45.0"
  length2="50.0"
  name="geom_100keV.h5m"
  tol="1e-3"
elif [ ${energy} = "0.01" ]; then
  echo "Constructing geometry for source energy 0.01 MeV!"
  radius="0.5"
  length1="1.5"
  length2="2.0"
  name="geom_10keV.h5m"
  tol="1e-5"
elif [ ${energy} = "0.001" ]; then
  echo "Constructing geometry for source energy 0.001 MeV!"
  radius="0.01"
  length1="0.05"
  length2="0.1"
  name="geom_1keV.h5m"
  tol="1e-5"
else
  echo "The desired energy ${energy} is currently not supported!"
  exit 1
fi

# Create sphere
echo "sphere r ${radius}" >> temp_file

# Create termination cell
echo "brick x ${length1} y ${length1} z ${length1}" >> temp_file
echo "brick x ${length2} y ${length2} z ${length2}" >> temp_file
echo "subtract volume 2 from volume 3" >> temp_file

# Imprint and merge
echo "imprint body all" >> temp_file
echo "merge tol 5e-7" >> temp_file
echo "merge all" >> temp_file

# Set groups
echo "group 'termination.cell' add vol 4" >> temp_file
echo "group 'material_1_density_-0.00008988' add vol 1" >> temp_file
echo "group 'estimator_1.cell.tl.flux.e' add vol 1" >> temp_file
echo "group 'estimator_2.surface.flux.e' add surface 1" >> temp_file
echo "group 'estimator_3.surface.current.e' add surface 1" >> temp_file

# export .h5m file
echo "export dagmc '${name}' faceting_tolerance ${tol} make_watertight" >> temp_file

# comment out this line to not automatically exit Trelis
echo "exit" >> temp_file

trelis temp_file

rm temp_file
rm *.jou