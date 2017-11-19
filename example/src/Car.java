public class Car {
	String model;
	
	public Car(String nModel) {
		this.model = nModel;
	}
	
	public void setModel(String nModel, int number) {
		if (nModel == "bla" || nModel == "bal") {
			this.model = "bal";
		}
		this.model = nModel;
	}
}