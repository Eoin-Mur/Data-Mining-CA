class Point
{
	double x;
	double y;

	Point(double x1,double y1)
	{
		x = x1;
		y = y1;
	}
}

public class Q2Dists {

	public static double distance(Point i, Point j)
	{
		return Math.sqrt( Math.pow((i.x-j.x), 2) + Math.pow((i.y-j.y), 2));
	}
	
	public static void main(String [] args)
	{
		Point[] p = {
			new Point(10.9,12.6),
			new Point(2.3,8.4),
			new Point(8.4,12.6),
			new Point(12.1,16.2),
			new Point(7.3,8.9),
			new Point(23.4,11.3),
			new Point(19.7,18.5),
			new Point(17.1,17.2),
			new Point(3.2,3.4),
			new Point(1.3,22.8),
			new Point(2.4,6.9),
			new Point(2.4,7.1),
			new Point(3.1,8.3),
			new Point(2.9,6.9),
			new Point(11.2,4.4),
			new Point(8.3,8.7)
			};	

		Point [] c = {
			new Point(2.7,6.8),
			new Point(7.9,11.6),
			new Point(18.0,15.8)
		};


		for(int i = 0; i < p.length; i++)
		{
			System.out.println(i+": "+p[i].x+","+p[i].y+" d1="+distance(p[i],c[0])+" d2="+distance(p[i],c[1])+" d3="+distance(p[i],c[2])+"\n");

		}
	}
	
}