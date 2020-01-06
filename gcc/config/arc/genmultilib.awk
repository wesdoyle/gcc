# Copyright (C) 2016-2020 Free Software Foundation, Inc.
#
# This file is part of GCC.
#
# GCC is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# GCC is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with GCC; see the file COPYING3.  If not see
# <http://www.gnu.org/licenses/>.

##################################################################
#
# This file is using AVR's genmultilib.awk idea.
# Transform CPU Information from arc-cpu.def to a
# Representation that is understood by GCC's multilib Machinery.
#
# The Script works as a Filter from STDIN to STDOUT.
#
# FORMAT = "Makefile": Generate Makefile Snipet that sets some
#                      MULTILIB_* Variables as needed.
#
##################################################################

BEGIN {
  FS ="[(, \t)]+"
  comment = 1
  n_cores = 0
  n_reuse = 0
}

##################################################################
# Add some Comments to the generated Files and copy-paste
# Copyright Notice from above.
##################################################################
/^#/ {
  if (!comment)
    next
  else if (comment == 1)
    {
      if (FORMAT == "Makefile")
	{
	  print "# Auto-generated Makefile Snip"
	  print "# Generated by    : ./gcc/config/arc/genmultilib.awk"
	  print "# Generated from  : ./gcc/config/arc/arc-cpu.def"
	  print "# Used by         : tmake_file from Makefile and genmultilib"
	  print ""
	}
    }

  comment = 2;

  print
}

/^$/ {
  # The first empty line stops copy-pasting the GPL comments
  # from this file to the generated file.

  comment = 0
}


/^ARC_CPU/ {
  name = $2
  #  gsub ("\"", "", name)

  if ($4 != "0")
    {
      arch = $3
      if (arch == "6xx")
	arch = 601

      n = split ($4, cpu_flg, "|")

      line = "mcpu." arch
      for (i = 1; i <= n; i++)
	{
	  if (cpu_flg[i] == "FL_MPYOPT_0")
	    line = line "/mmpy-option.0"
	  else if (cpu_flg[i] == "FL_MPYOPT_1")
	    line = line "/mmpy-option.1"
	  else if (cpu_flg[i] == "FL_MPYOPT_2")
	    line = line "/mmpy-option.2"
	  else if (cpu_flg[i] == "FL_MPYOPT_3")
	    line = line "/mmpy-option.3"
	  else if (cpu_flg[i] == "FL_MPYOPT_4")
	    line = line "/mmpy-option.4"
	  else if (cpu_flg[i] == "FL_MPYOPT_5")
	    line = line "/mmpy-option.5"
	  else if (cpu_flg[i] == "FL_MPYOPT_6")
	    line = line "/mmpy-option.6"
	  else if (cpu_flg[i] == "FL_MPYOPT_7")
	    line = line "/mmpy-option.7"
	  else if (cpu_flg[i] == "FL_MPYOPT_8")
	    line = line "/mmpy-option.8"
	  else if (cpu_flg[i] == "FL_MPYOPT_9")
	    line = line "/mmpy-option.9"
	  else if (cpu_flg[i] == "FL_CD")
	    line = line "/mcode-density"
	  else if (cpu_flg[i] == "FL_BS")
	    line = line "/mbarrel-shifter"
	  else if (cpu_flg[i] == "FL_DIVREM")
	    line = line "/mdiv-rem"
	  else if (cpu_flg[i] == "FL_NORM" \
		   || cpu_flg[i] == "FL_SWAP")
	    line = line "/mnorm"
	  else if (cpu_flg[i] == "FL_FPU_FPUS")
	    line = line "/mfpu.fpus"
	  else if (cpu_flg[i] == "FL_FPU_FPUDA")
	    line = line "/mfpu.fpuda"
	  else if (cpu_flg[i] == "FL_FPU_FPUD_ALL")
	    line = line "/mfpu.fpud_all"
	  else if (cpu_flg[i] == "FL_LL64")
	    line = line "/mll64"
	  else if (cpu_flg[i] == "FL_MUL64")
	    line = line "/mmul64"
	  else if (cpu_flg[i] == "FL_MUL32x16")
	    line = line "/mmul32x16"
	  else if (cpu_flg[i] == "FL_FPX_QUARK")
	    line = line "/quark"
	  else if (cpu_flg[i] == "FL_SPFP")
	    line = line "/spfp"
	  else if (cpu_flg[i] == "FL_DPFP")
	    line = line "/dpfp"
	  else if (cpu_flg[i] == "FL_RF16")
	    line = line "/mrf16"
	  else
	    {
	      print "Don't know the flag " cpu_flg[i] > "/dev/stderr"
	      exit 1
	    }
	}
      line = "mcpu." name "=" line
      reuse[n_reuse] = line
      n_reuse++
    }

  core = name
  cores[n_cores] = core
  n_cores++
}

##################################################################
#
# We gathered all the Information, now build/output the following:
#
#    awk Variable         target Variable          FORMAT
#  -----------------------------------------------------------
#    m_options     <->    MULTILIB_OPTIONS         Makefile
#    m_dirnames    <->    MULTILIB_DIRNAMES           "
#
##################################################################

END {
  m_options    = "\nMULTILIB_OPTIONS = "
  m_dirnames   = "\nMULTILIB_DIRNAMES ="
  m_reuse      = "\nMULTILIB_REUSE ="

  sep = ""
  for (c = 0; c < n_cores; c++)
    {
      m_options  = m_options sep "mcpu=" cores[c]
      m_dirnames = m_dirnames " " cores[c]
      sep = "/"
    }

  sep = ""
  for (c = 0; c < n_reuse; c++)
    {
      m_reuse = m_reuse sep reuse[c]
      sep = "\nMULTILIB_REUSE +="
    }
  ############################################################
  # Output that Stuff
  ############################################################

  if (FORMAT == "Makefile")
    {
      # Intended Target: ./gcc/config/arc/t-multilib

      print m_options
      print m_dirnames

      ############################################################
      # Legacy Aliases
      ############################################################

      print ""
      print "# Aliases:"
      print "MULTILIB_MATCHES  = mcpu?arc600=mcpu?ARC600"
      print "MULTILIB_MATCHES += mcpu?arc600=mARC600"
      print "MULTILIB_MATCHES += mcpu?arc600=mA6"
      print "MULTILIB_MATCHES += mcpu?arc601=mcpu?ARC601"
      print "MULTILIB_MATCHES += mcpu?arc700=mA7"
      print "MULTILIB_MATCHES += mcpu?arc700=mARC700"
    }
}
