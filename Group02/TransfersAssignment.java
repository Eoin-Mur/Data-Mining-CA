import java.io.FileInputStream;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;

public class TransfersAssignment {
	
	public static String[][] getPositionDiffPrevYear(Connection conn, Statement stmt, double p,String team,String league,int testFlag)
	{
		ResultSet rs = null;
		String a[][] = new String[1][2];
		try
		{
			String query = "";
			if( testFlag == 1 )
				query = "SELECT t1.Position,t1.league as prevLeague FROM FinalDataset t1 WHERE t1.Team = '"+team+"' and t1.Season <> '2014' Order by t1.Season DESC LIMIT 1;";
			else
				query = "SELECT t1.Position,t1.league as prevLeague FROM FinalDataset t1 WHERE t1.Team = '"+team+"' Order by t1.Season DESC LIMIT 1;";
			rs = stmt.executeQuery(query);
			rs.next();
			int position = rs.getInt("Position");
			String prevLeague = rs.getString("prevLeague");
			a[0][0] = String.valueOf(position);
			a[0][1] = String.valueOf(position-(int)p);

			if(league.equals("barclays-premier-league"))
			{
				if(position > 17)
				{
					a[0][0] = "Relegated from PL";
					a[0][1] = String.valueOf(24 - (int)p);
				}
				if(prevLeague.equals("english-league-championship"))
				{
					a[0][0] = "Promoted from c'ship";
					a[0][1] = String.valueOf(20 - (int)p);
				}
			}	
			else if (league.equals("english-league-championship"))
			{
				if(position >= 22)
				{
					a[0][0] = "Relegated from PL";
					a[0][1] = String.valueOf(24 - (int)p);
				}
				if(prevLeague.equals("english-league-one")){
					a[0][0] = "Promoted from Lg1";
					a[0][1] = String.valueOf(24 - (int)p);
				}
			}	
			else if(league.equals("english-league-one"))
			{
				if(position >= 21)
				{
					a[0][0] = "Relegated from c'ship";
					a[0][1] = String.valueOf(24 - (int)p);
				}
				if(prevLeague.equals("english-league-two")){
					a[0][0] = "Promoted from Lg2";
					a[0][1] = String.valueOf(24 - (int)p);
				}
			}
			else if(league.equals("english-league-two"))
			{
				if(position >= 20)
				{
					a[0][0] = "Relegated from Lg1";
					a[0][1] = String.valueOf(24- (int)p);
				}
			}	
			if(Integer.parseInt(a[0][1]) < 1)
			{
				a[0][1] = "1";
			}else if(Integer.parseInt(a[0][1]) > 20 && league.equals("barclays-premier-league"))
			{
				a[0][1] = "20";
			}
			else if(Integer.parseInt(a[0][1]) > 24)
			{
				a[0][1] = "24";
			}
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
	
	public static double getHighestDist(double m[][])
	{
		double highest = m[0][0];
		for( int i = 1; i < m.length; i++ )
		{
			if(m[i][0] > highest)
				highest = m[i][0];
		}
		return highest;
	}
	
	//Not used just left in in case we dont want to calc diffs
	public static double[][] resultSetToMatrix(ResultSet rs)
	{
		int numRows = 0;
		
		try
		{
			if( rs.last() )
			{
				numRows = rs.getRow();
				rs.beforeFirst();
			}
			
			double[][] a = new double[numRows][3];

			int i = 0;
			while( rs.next() )
			{
				double spend = rs.getDouble("Spend");
				double income = rs.getDouble("Income");
				double position = rs.getDouble("Position");
				
				a[i][0] = spend;
				a[i][1] = income;
				a[i][2] = position;
				
				i++;
			}
			 return a;
		}catch(SQLException e)
		{
			System.out.println("SQLException: " + e.getMessage());
		    System.out.println("SQLState: " + e.getSQLState());
		    System.out.println("VendorError: " + e.getErrorCode());
		    
		}
		return null;
	}
	
	public static double selectClassifer(double[][] NN, int k)
	{
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
		
		
		//Kinda a sketcy way to do this as it assumes the indexs in classifiers and counts will always relate correctly
		double[][] classifiers = new double[k][1];
		double[][] counts = new double[k][1];
		int i;
		boolean found = false;
		for( i = 0; i < NN.length; i++ )
		{
			for(int j = 0; j < classifiers.length;j++)
			{
				//System.out.println("arse: "+classifiers[j][0]+": == "+NN[i][1]);
				if( classifiers[j][0] ==  NN[i][1] && i!=0)
				{
					counts[j][0]++;
					found = true;
				}
			}
			if(found == false)
			{
				classifiers[i][0] = NN[i][1];
				counts[i][0]++;
			}
			found = false;
		}
		
		double highestCount = counts[0][0];
		int highestIndex = 0;
		
		for( i = 0; i < classifiers.length; i++ )
		{
			//System.out.println("class: "+classifiers[i][0]+" count: "+counts[i][0]);
			if( counts[i][0] > highestCount )
			{
				highestCount = counts[i][0];
				highestIndex = i;
			}
			//if(counts[i][0]==0)break; 
		}
		
		if( highestCount == 1 )
		{
			return classifiers[0][0];
		}
		else
		{
			return classifiers[highestIndex][0];
		}
		
	}
	
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
			//use the highest value to start
			NN[i][0] = getHighestDist(m);
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

	public static double[][] calcNNMatrix(double[][] a,double ps, double pi)
	{
		//matrix parameters must be in format {spend,income,position}
		//returned matrix is distance mapped to class
		double r[][] = new double[a.length][2];
		for( int i = 0; i < a.length; i++ )
		{
			r[i][0] = euclideanDist(a[i][0],a[i][1], ps, pi);
			r[i][1] = a[i][2];
		}
		return r;
	}
	
	public static double euclideanDist(double s, double i, double ps, double pi)
	{
		// i and s are the income and spend in the training set
		//pi and ps are the income and spend in our unseen set(value we are making a predictions off)	
		return Math.sqrt( Math.pow((s-ps), 2) + Math.pow((i-pi), 2) );
	}
	
	public static double[][] returnDiffs(ResultSet rs)
	{
		int numRows = 0;
		
		try
		{
			if( rs.last() )
			{
				numRows = rs.getRow();
				rs.beforeFirst();
			}
			
			double[][] diffsArray = new double[numRows-1][3];
			int i = 0;
			//need to save the previous years value for calculations 
			double prevS = 1;
			double prevI = 1;
			double prevP = 1;
			while( rs.next() )
			{
				double spend = rs.getDouble("Spend");
				double income = rs.getDouble("Income");
				double position = rs.getDouble("Position");
				
				if(i != 0 )
				{
					diffsArray[i-1][0] = prevS - spend;
					diffsArray[i-1][1] = prevI - income;
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
		System.out.println("----------\n");
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
		System.out.println("----------\n");
	}
	
	public static ResultSet getDataOnTeam(Connection conn,Statement stmt,String team,String league,int testFlag)
	{
		ResultSet rs = null;
		
		try
		{
			String query = "";
			if( testFlag == 1 )
				query = "SELECT * FROM FinalDataset WHERE league = '"+league+"' and season <> 2014 group by team,season order by team, season desc;";
			else
				query = "SELECT * FROM FinalDataset WHERE league = '"+league+"' group by team,season order by team, season desc;";
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
	
	public static double[][] getDiffInPredValue(Connection conn, Statement stmt, String team,double predSpend, double predIncome,int testFlag)
	{
		ResultSet rs = null;
		try
		{
			String query = "";
			if( testFlag == 1 )
				query = "SELECT Spend, Income FROM FinalDataset WHERE Team = '"+team+"' and Season <> '2014' Order by Season DESC LIMIT 1";
			else
				query = "SELECT Spend, Income FROM FinalDataset WHERE Team = '"+team+"' Order by Season DESC LIMIT 1";
			rs = stmt.executeQuery(query);
			rs.next();
			double spend = rs.getDouble("Spend");
			double income = rs.getDouble("Income");
			
			double[][] a = new double[1][2];
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
	
	public static String[][] get2014(Connection conn, Statement stmt)
	{
		ResultSet rs = null;
		int numRows = 0;
		try
		{
			
			String query = "SELECT team,league,spend,income FROM FinalDataset WHERE Season = '2014' order by league";
			rs = stmt.executeQuery(query);
			
			if( rs.last() )
			{
				numRows = rs.getRow();
				rs.beforeFirst();
			}
			
			String [][] a = new String[numRows][4];
			int i = 0;
			while( rs.next() )
			{
				a[i][0] = rs.getString("team");
				a[i][1] = rs.getString("Spend");
				a[i][2] = rs.getString("Income");
				a[i][3] = rs.getString("League");
				i++;
			}
			return a;
			
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
		
		return null;
	}
	
	public static double norm(double i,int type)
	{
		if(type == 1)
			return (i-0)/(181700000-0);
		else
			return (i-0)/(141160000-0);
	}
	
	public static void runTestData(Connection conn,Statement stmt)
	{
		int K = 4;
		String predteam = null;
		double predSpend = 0;
		double predIncome = 0;
		String predLeague = "";
		
		ResultSet rs = null;
		
		String [][] aa = get2014(conn,stmt);
		
		String pl ="";
		for(int k = 0; k < aa.length; k++)
		{
			if( aa[k] ==null )break;
			predteam = aa[k][0];
			predSpend = Double.parseDouble(aa[k][1]);
			predIncome = Double.parseDouble(aa[k][2]);
			predLeague = aa[k][3];

			rs = getDataOnTeam(conn,stmt,predteam,predLeague,1);
			double diffs[][] = returnDiffs(rs);
			
			double a[][] = getDiffInPredValue(conn,stmt,predteam,predSpend,predIncome,1);
			predSpend = a[0][0];
			predIncome = a[0][1];
			
			//System.out.println(predSpend+",,"+predIncome);
			double nnMatrix[][] = calcNNMatrix(diffs, predSpend, predIncome);
			//test2DArray(nnMatrix);
			double kMatrix[][] = selectKNeighbors(K,nnMatrix);
			//System.out.println(K+"-NN Matrix");
			//test2DArray(kMatrix);
			double classifier = selectClassifer(kMatrix,K);
			//System.out.println("Predicted Classifer is "+classifier);
			String b[][] = getPositionDiffPrevYear(conn,stmt,classifier,predteam,predLeague,1);
			if(k==0)
			{
				pl=predLeague;
				System.out.println("----------"+pl+"-------------\n");
			}
			else if( predLeague.equals(pl) == false )
			{
				System.out.println();
				pl=predLeague;
				System.out.println("----------"+pl+"-------------");
			}
			System.out.println(predteam+": "+b[0][0]+" to positon "+b[0][1]);
		}
		System.out.println("--------------------------------------");
		
	}
	
	public static void main(String[] args)
	{
		int K = 4;
		String predteam = null;
		double predSpend = 0;
		double predIncome = 0;
		String predLeague = "";
		
		String dbURL = "jdbc:mysql://localhost/data_mining_assignment";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		
		if( args.length == 4)
		{
			predteam = args[0];
			try
			{
				predSpend = norm(Double.parseDouble(args[1]),1);
				predIncome = norm(Double.parseDouble(args[2]),0);
				predLeague = args[3];
			}
			catch(NumberFormatException e)
			{
				System.out.println("Spend or Income not a interger value");
				System.out.println("Usage:");
				System.out.println("java TransferAssignment 'String' 'int' 'int'");
				return;
			}
		}
		else if( args.length == 1 && !args[0].equals("test") )
		{
			System.out.println("Usage:");
			System.out.println("java TransferAssignment ");
			System.out.println("java TransferAssignment 'team' spend income");
			System.out.println("java TransferAssignment 'test' ");
			System.out.println("\nStrings which incude spaces must be enclosed\nin double quotes for cmd line params!");
			return;
		}
		else if( args.length == 0 )
		{
			Scanner in = new Scanner(System.in);
			System.out.print("Enter Team: ");
			predteam = in.nextLine();
			System.out.print("Enter Spend: ");
			predSpend = norm(in.nextInt(),1);
			System.out.print("Enter Income: ");
			predIncome = norm(in.nextInt(),0);
			System.out.print("1 : barclays-premier-league,\n"+
					"2 : english-league-championship,\n"+
					"3 : english-league-one,\n"+
					"4 : english-league-two,\n"+
					"Choose League Number: ");
			int choice = in.nextInt();
			in.close();
			switch(choice)
			{
				case 1: predLeague = "barclays-premier-league";
						break;
				case 2:	predLeague = "english-league-championship";
						break;
				case 3: predLeague = "english-league-one";
						break;
				case 4: predLeague = "english-league-two";
						break;
				default:System.out.println("Invalid Choice");
						return;
			}
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

			if( args.length == 1 && args[0].equals("test"))
			{
				stmt = conn.createStatement();
				runTestData(conn,stmt);
			}
			else
			{
				stmt = conn.createStatement();
				
				rs = getDataOnTeam(conn,stmt,predteam,predLeague,0);
				double diffs[][] = returnDiffs(rs);
				
				double a[][] = getDiffInPredValue(conn,stmt,predteam,predSpend,predIncome,0);
				predSpend = a[0][0];
				predIncome = a[0][1];
				
				double nnMatrix[][] = calcNNMatrix(diffs, predSpend, predIncome);
				//test2DArray(nnMatrix);
				double kMatrix[][] = selectKNeighbors(K,nnMatrix);
				//test2DArray(kMatrix);
				double classifier = selectClassifer(kMatrix,K);
				//System.out.println("Predicted Classifer is "+classifier);
				String b[][] = getPositionDiffPrevYear(conn,stmt,classifier,predteam,predLeague,0);
				System.out.println(predteam+": "+b[0][0]+" to positon "+b[0][1]);
			}
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
					//System.out.println("Closed Result Set");
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
		            //System.out.println("Closed Statment");
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
		            //System.out.println("Closed Connection");
		        } 
		        catch (SQLException sqlEx) { } 
		        conn = null;
		    }
		    
		}
	}
}
