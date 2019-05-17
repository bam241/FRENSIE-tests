#!/usr/bin/python
import sys, os
from optparse import *
sys.path.append(os.path.join(os.path.dirname(__file__), '../../..'))
from infinite_medium_simulation import runAdjointInfiniteMediumSimulation
import PyFrensie.Utility as Utility
import PyFrensie.MonteCarlo as MonteCarlo

if __name__ == "__main__":
    
    # Parse the command line options
    parser = OptionParser()
    parser.add_option("--threads", type="int", dest="threads", default=1,
                      help="the number of threads to use")
    parser.add_option("--db_path", type="string", dest="db_path",
                      help="the database name (with extension)")
    parser.add_option("--sim_name", type="string", dest="sim_name", default="sphere",
                      help="the simulation name")
    parser.add_option("--log_file", type="string", dest="log_file",
                      help="the file that will be used for logging")
    parser.add_option("--num_particles", type="float", dest="num_particles", default=1e3,
                      help="the number of particles to run")
    options,args = parser.parse_args()

    if options.db_path is None:
        print "The database path must be specified!"
        sys.exit(1)

    # Run the simulation
    runAdjointInfiniteMediumSimulation( options.sim_name,
                                        options.db_path,
                                        "../../../infinite_medium.h5m",
                                        options.num_particles,
                                        MonteCarlo.WH_INCOHERENT_ADJOINT_MODEL,
                                        1e-3,
                                        0.5,
                                        Utility.doubleArrayFromString( "{1e-3, 499i, 0.5}" ),
                                        options.threads,
                                        options.log_file )
    
    
