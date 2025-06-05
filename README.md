Loading the LA Crime Dataset into SQLite
This project uses publicly available crime data from the City of Los Angeles, hosted on Data.gov, the U.S. government's open data portal.

Steps to Set Up (macOS)
If you're on Linux or Windows, refer to the SQLite documentation for platform-specific instructions.

1. Download the dataset
Visit the dataset page: https://catalog.data.gov/dataset/crime-data-from-2020-to-present 
Click "Download" to get the CSV file.

2. Create a new SQLite database
Open DB Browser for SQLite

Go to File > New Database

Choose a filename and location (e.g., la_crime.sqlite) and click Save

A pop-up titled "Edit table definition" will appear — click Cancel

3. Import the CSV as a table
Go to File > Import > Table from CSV file

Select the downloaded CSV file

Set Table name to: crime

Make sure the Field separator is set to , (comma)

Preview the data to confirm it looks like a spreadsheet

Click OK

The crime data is now loaded into SQLite and ready for querying.
