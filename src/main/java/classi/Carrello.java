package classi;

import java.util.ArrayList;

public class Carrello {
    ArrayList<Integer> canzoni;

    public Carrello() {
        canzoni = new ArrayList<>();
    }

    public ArrayList<Integer> getID() {
        return canzoni;
    }

    public int numeroCanzoni() {
        return canzoni.size();
    }

    public void aggiungi(int a) {
        canzoni.add(a);
    }

    public void elimina(int id) {
        canzoni.remove(Integer.valueOf(id));
    }
}
