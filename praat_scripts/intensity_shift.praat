# # ## ### ##### ########  #############  ##################### 
## Scale intensity of all sounds in a Directory
##### Check for clipped extrema
# Give an option to lower the output level 
# until none of the sounds are clipped
#
## Matthew B. Winn
## March 2020
#
## NOTE: It helps to have the Praat info window open as you run this script,
###### as it will update info for you as it proceeds. 
#
## Once the script is done and you choose to save the files, 
#### Look in the original sound directory - 
#### there you will find a new sub-folder of normalized sounds. 
##################################
##################### 
############# 
######## 
#####
###
##
#
#
form Input Enter specifications for Intensity scaling
    comment Enter desired intensity (dB):
    	real intensity 75
    comment Enter directory where the ORIGINAL sound files will be retrieved:
    	sentence soundDir C:\Enter-Your-Directory-Here
    comment Enter filename to which the info should be written
    	sentence outFile intensity_info.txt
endform



call changeIntensities


procedure changeIntensities
   clearinfo
   clippedSounds = 0

   # Reads in a list of files
	Create Strings as file list... list 'soundDir$'/*.wav
	numberOfFiles = Get number of strings

   # make a list of each sound in the directory
   for thisFile to numberOfFiles
      select Strings list
      fileName$ = Get string... thisFile
      name$ = fileName$ - ".wav"

     # Reads in all sound (wav) files
	Read from file... 'soundDir$'/'name$'.wav

     # get intensity of the original sound
	old_Int = Get intensity (dB)
		print 'name$' was 'old_Int:1'   

     # scale it to the user-defined intensity
	Scale intensity... 'intensity'
	int_diff = 'intensity' - 'old_Int'
		print & adjusted by 'int_diff:2' to get 'intensity:1' 'tab$'

     # Check to see if it clips
	max = Get absolute extremum... 0 0 Sinc70
	if max >= 1
		clippedSounds = clippedSounds + 1
		print CLIPPED
	endif

	# wrap to the next line
		print 'newline$'
	
	# Remove the sound object from the objects list 
	Remove

   endfor

   # decide whether you want to save the files
	call userSelectSave
endproc

procedure userSelectSave
	choice = 1

   beginPause ("'clippedSounds' sounds have been clipped (see info window for details)")
   	comment ("'clippedSounds' sounds have been clipped")
	comment ("Do you want to save the files?")
       optionMenu ("Choice", choice)
          option ("Yes - save the sounds")
          option ("No - Quit")
          option ("Lower level by 1 dB and measure again")
          option ("Lower level by 2 dB and measure again")
          option ("Lower level by 3 dB and measure again")
          option ("Lower level by 4 dB and measure again")
          option ("Lower level by 5 dB and measure again")

       comment ("Then click Continue.")

endPause ("Continue", 1)
 	if choice = 1
 		call saveSounds

 	elsif choice = 2
 		select all
 		Remove
 	else
 	 	select all
 		Remove
 		# lower by 5 is the 7th choice, lower by 4 is the 6th choice;
 		# adjustment is the choice # minus 2 
	 	intAdjustment = choice-2
	 	intensity = intensity-(intAdjustment)
	 	call changeIntensities
	endif
endproc

procedure saveSounds
   # makes a directory
   new_directory$ = "'soundDir$'" + "/" + "_Intensity'intensity'"
   createDirectory: new_directory$

   # first deletes any existing output file
	filedelete 'soundDir$'/'outFile$'

   # creates simple header		
	#fileappend Step 'tab$' Duration 'tab$' 'newline$'

   # make a list of each sound in the directory
   for thisFile to numberOfFiles
      select Strings list
      fileName$ = Get string... thisFile
      name$ = fileName$ - ".wav"

   # Reads in the sound (wav) file
	Read from file... 'soundDir$'/'name$'.wav

   # scale it to the user-defined intensity (updated to reflect clip-adjustment changes)
	Scale intensity... 'intensity'

   # save it
	Save as WAV file... 'new_directory$'/'name$'.wav
	Remove
endfor

    call saveInfoWindow "'new_directory$'" _Intensity_Info

select Strings list
Remove
endproc

procedure saveInfoWindow outputDirectory$ outputFileName$
	filedelete 'outputDirectory$'/'outputFileName$'.txt
	fappendinfo 'outputDirectory$'/'outputFileName$'.txt
endproc

# 
# 
## 
### 
##### 
######## 
############# 
##################### 
################################## DONE