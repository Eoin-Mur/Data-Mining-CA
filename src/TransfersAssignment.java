import java.io.FileInputStream;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class TransfersAssignment {
	
	//AVEREGE SPEND PER POINT!!!!!!!!!
	
	
	//NEED TO CREATE THIS SQL STATMENT IN JAVA CODE :(
	//select top 1 Distinct class, Count(class) as count GROUP BY class ORDER BY count DESC 
	//i will take reasons i like SQL for 4000, Alex!
	
	//Hacky/inefficient way to do it:
	//	1. send sql cmd to create a temp table with 2 columns
	//	2. insert the NN matrix to this table
	//	3. send the command above
	//	4. for the length of result set returned 
	//	5. read current count
	//	6. if next count in result set is greater then prev
	//	7. set that as largest.
	// 	8. no more rows return largest.
	// 	9. drop temp table created.
	
	/*
	public static int selectClassifer(double[][] NN)
	{
		int[][] countMatrix = new int[NN.length][2];
		for( int i = 0; i < NN.length; i++ )
		{
			
		}
		
	}
	*/
	public static double[][] insert(double d,double c, double[][] m)
	{
		double tempD;
		double tempC;
		for( int i = 0; i < m.length; i++ )
		{
			if( d < m[i][0] )
			{
				tempD = m[i][0];
				tempC = m[i][1];
				
				m[i][0] = d;
				m[i][1] = c;
				m = insert(tempD,tempC,m);
				break;
			}
		}
		return m;
	}
	
	public static double[][] selectKNeighbors(int k, double[][] m)
	{
		int i;
		double curDist;
		double curClass;
		double NN[][] = new double[k][2];
		for( i = 0; i < NN.length; i++ )
		{
			//just hard code in a crazy high value in the initalization in the mean time
			//TODO: Write a function to get the highest value in the matrix to initalize on 
			NN[i][0] = 100000000.0;
			NN[i][1] = 0.0;
		}
		
		for( i = 0; i < m.length; i++ )
		{
			curDist = m[i][0];
			curClass = m[i][1];
			NN = insert(curDist,curClass, NN);
		}
		
		return NN;
	}

	
	//matrix parameters must be in format {spend,income,position}
	//returned matrix is distance mapped to class
	public static double[][] calcNNMatrix(int[][] a,int ps, int pi)
	{
		double r[][] = new double[a.length][2];
		for( int i = 0; i < a.length; i++ )
		{
			r[i][0] = euclideanDist(a[i][0],a[i][1], ps, pi);
			r[i][1] = a[i][2];
		}
		return r;
	}
	
	// i and s are the income and spend in the training set
	//pi and ps are the income and spend in our unseen set(value we are making a predictions off).
	public static double euclideanDist(int s, int i, int ps, int pi)
	{
		return Math.sqrt( Math.pow(s-i, 2) + Math.pow(ps-pi, 2) );
	}
	
	public static double distance(int s, int i, int ps, int pi)
	{
		return (s - ps) + (i - pi);
	}
	
	public static int[][] returnDiffs(ResultSet rs)
	{
		int numRows = 0;
		
		try
		{
			if( rs.last() )
			{
				numRows = rs.getRow();
				rs.beforeFirst();
			}
			
			int[][] diffsArray = new int[numRows-1][3];
			int i = 0;
			//need to save the previous years value for calculations 
			int prevS = 1;
			int prevI = 1;
			int prevP = 1;
			while( rs.next() )
			{
				int spend = rs.getInt("Spend");
				int income = rs.getInt("Income");
				int position = rs.getInt("Position");
				
				if(prevS != 1 && prevI != 1 && prevP != 1)
				{
					diffsArray[i-1][0] = spend - prevS;
					diffsArray[i-1][1] = income - prevI;
					diffsArray[i-1][2] = prevP - position;
				}
				
				prevS = spend;
				prevI = income;
				prevP = position;
				
				i++;
			}
			 return diffsArray;
		}catch(SQLException e)
		{
			System.out.println("SQLException: " + e.getMessage());
		    System.out.println("SQLState: " + e.getSQLState());
		    System.out.println("VendorError: " + e.getErrorCode());
		    
		}
		return null;
	}
	
	public static void test2DArray(int[][] a)
	{
		System.out.println("----------");
		for( int i = 0; i < a.length; i++ )
		{
			for(int j = 0; j < a[i].length; j++)
			{
				System.out.print(a[i][j] + " ");
			}
			System.out.println();
		}
		System.out.println("----------");
	}
	
	public static void test2DArray(double[][] a)
	{
		System.out.println("----------");
		for( int i = 0; i < a.length; i++ )
		{
			for(int j = 0; j < a[i].length; j++)
			{
				System.out.print(a[i][j] + " ");
			}
			System.out.println();
		}
		System.out.println("----------");
	}
	
	public static ResultSet getDataOnTeam(Connection conn,Statement stmt,String team)
	{
		ResultSet rs = null;
		
		try
		{
			
			String query = "SELECT * FROM cleaned_table_join WHERE Team = '"+team+"' and Season <> '2014' Order by Season ASC";
			rs = stmt.executeQuery(query);
			
		}catch(SQLException ex)
		{
		    System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return rs;
	}
	
	public static int[][] getDiffInPredValue(Connection conn, Statement stmt, String team,int predSpend, int predIncome)
	{
		ResultSet rs = null;
		try
		{
			
			String query = "SELECT Spend, Income FROM cleaned_table_join WHERE Team = '"+team+"' and Season <> '2014' Order by Season DESC LIMIT 1";
			rs = stmt.executeQuery(query);
			rs.next();
			int spend = rs.getInt("Spend");
			int income = rs.getInt("Income");
			
			int[][] a = new int[1][2];
			a[0][0] = predSpend - spend;
			a[0][1] = predIncome - income;
			
			return a;
			
		}catch(SQLException ex)
		{
		    System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		finally
		{
			try
			{
				rs.close();
			}
			catch(SQLException e){}
		}
		return null;
	}
	
	public static void main(String[] args)
	{
		int K = 4;
		String predteam = null;
		int predSpend = 0;
		int predIncome = 0;
		
		String dbURL = "jdbc:mysql://localhost/data_mining_assignment";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		
		if( args.length == 3)
		{
			predteam = args[0];
			try
			{
				predSpend = Integer.parseInt(args[1]);
				predIncome = Integer.parseInt(args[2]);
			}
			catch(NumberFormatException e)
			{
				System.out.println("Spend or Income not a interger value");
				System.out.println("Usage:");
				System.out.println("java TransferAssignment 'String' 'int' 'int'");
				return;
			}
			System.out.println("Predicting Position Increase");
			System.out.println("for team "+predteam);
			System.out.println("Based off Spending of "+predSpend);
			System.out.println("and a income of "+predIncome+"....\n");
		}
		else
		{
			System.out.println("Usage:");
			System.out.println("java TransferAssignment 'team' 'spend' 'income'");
			return;
		}
		
		try
		{
			//Load our driver into memory   FinalTransfersDataset
			Class.forName("com.mysql.jdbc.Driver");
			
			//load credentials for SQL connection
			Properties config = new Properties();
			FileInputStream in = new FileInputStream("C:\\data-minning-config.properties");
			config.load(in);
			conn = DriverManager.getConnection(dbURL,config);

			stmt = conn.createStatement();
			
			rs = getDataOnTeam(conn,stmt,predteam);
			int diffs[][] = returnDiffs(rs);
			//test2DArray(diffs);
			
			int a[][] = getDiffInPredValue(conn,stmt,predteam,predSpend,predIncome);
			predSpend = a[0][0];
			predIncome = a[0][1];
			
			double nnMatrix[][] = calcNNMatrix(diffs, predSpend, predIncome);
			//test2DArray(nnMatrix);
			double kMatrix[][] = selectKNeighbors(K,nnMatrix);
			test2DArray(kMatrix);
			
		}
		catch(SQLException e)
		{
			System.out.println("SQLException: " + e.getMessage());
		    System.out.println("SQLState: " + e.getSQLState());
		    System.out.println("VendorError: " + e.getErrorCode());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
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
			//close our statement
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
