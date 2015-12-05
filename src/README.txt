Program requiments:
	MySQL java connector must be included in the build path.
	data set FinalDataset.csv loaded into a MySQL table Called FinalDataset.

Program usages:
	-Standard Usage
		-The program can be run with no command line arguments to allow the user to enter in the values from console.

	-Command line arguments usage
		-if the program is run with the command line argument as follows: java TransfersAssignmet test
			the program will execute and predict of the test data.
			
		-the values that would be entered into the console can be passed as command line arguments as follows:
			java TransfersAssignment "team name" spend income "league name"

			NOTE: if using the above command line argument has strings with spaces they should be enclosed in double quotes
						and the league name should be written as how it appears in the dataset.
