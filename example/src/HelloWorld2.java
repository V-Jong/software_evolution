public class HelloWorld2 {

    public static void cloneClassA() {    	
			int a = 0; // Also part of cloneClassB
			int b = 0; // Also part of cloneClassB
			int c = 0; // Also part of cloneClassB
			int d = 0; // Also part of cloneClassB
    }
    
    public static void cloneClassB() {    	
			int a = 0; // Also part of cloneClassB
			int b = 0; // Also part of cloneClassB
			int c = 0; // Also part of cloneClassB
			int d = 0; // Also part of cloneClassB
    }
    
    public static void method3() {
			int a = 0; // cloneClassB
			int b = 0; // cloneClassB
			int c = 0; // cloneClassB
			int d = 0; // cloneClassB
    }
}
