package x86;

	public class LocList {
		int[] locs;
		int size;
		

		public LocList () {
			locs = new int [1000];
			size = 0;
		}

		public void Add (int l) {
			locs[size] = l;
			size ++;
		}

		public void BackPatch (QuadTab q, Symbol label) {
			for (int i = 0; i < size; i ++) {
				q.BackPatch(locs[i], label);
			}
		
		}

		public void Merge (LocList ll) {
			
			if (ll.size == 0){
				System.out.println("In merge1.....");
				return;
			}
			if (size == 0){
				System.out.println("In merge2.....");
				locs = ll.locs;
				size = ll.size;
			}
			for (int i = 0; i < ll.size; i++) {
				locs[size] = ll.locs[i];
				size ++;
			}
		}

		public boolean IsEmpty () {
			return (size == 0);
		}

		public void Print () {
			for (int i = 0; i < size; i ++) {
				System.out.print(locs[i] + " ");
			}
			System.out.println("");
		}
	}