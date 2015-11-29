import java.io.FileInputStream;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class TransfersAssignment {
	public static void main(String[] args)
	{
		Connection conn = null;
		ResultSet rs = null;
		Statement stmt = null;
		String dbURL = "jdbc:mysql://localhost/data_mining_assignment";
		
		try
		{
			//Load our driver into memory   FinalTransfersDataset
			Class.forName("com.mysql.jdbc.Driver");
			
			//load credentials for SQL connection
			Properties config = new Properties();
			FileInputStream in = new FileInputStream("C:\\data-minning-config.properties");
			config.load(in);
			
			//establish connection to DB
			conn = DriverManager.getConnection(dbURL,config);
			
			//Create our procedure call and execute
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT * FROM FinalTransfersDataset");
			
			//while data still in the result set
			while(rs.next())
			{
				//read in each column
				String team = rs.getString("Team");
				String league = rs.getString("League");
				String season = rs.getString("Season");
				int spend = rs.getInt("Spend");
				int income = rs.getInt("Income");
				String points = rs.getString("Points");
				int position = rs.getInt("Position");
				
				//just print the data for now
				System.out.print("Team: "+ team);
				System.out.print(" League: "+ league);
				System.out.print(" Season: "+ season);
				System.out.print(" Spend: "+ spend);
				System.out.print(" Income: "+ income);
				System.out.print(" Points: "+ points);
				System.out.println(" Position: "+ position);
			}
		}
		//catch any SQL exceptions 
		catch(SQLException ex)
		{
		    System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		//catch any exception with loading driver
		catch(Exception e)
		{
			e.printStackTrace();
		}
		//clean up
		finally
		{
			// close the result set
			if(rs != null)
			{
				try
				{
					rs.close();
					System.out.println("Closed Result Set");
				} 
				catch (SQLException sqlEx) {}
			}
			rs = null;
			//close our procedure
		    if (stmt != null) 
		    {
		        try 
		        {
		        	stmt.close();
		            System.out.println("Closed Statment");
		        } 
		        catch (SQLException sqlEx) { } 
		        stmt = null;
		    }
		    //close our connection
		    if (conn != null) 
		    {
		        try 
		        {
		            conn.close();
		            System.out.println("Closed Connection");
		        } 
		        catch (SQLException sqlEx) { } 
		        conn = null;
		    }   
		}
	}
}
