package it.polimi.model;

import java.time.LocalDateTime;
import java.util.List;

public class Asta {
    private int id;
    private double prezzoIniziale;
    private int rialzoMinimo;
    private LocalDateTime scadenza;
    private boolean chiusa;
    private int venditoreId;
    private Integer vincitoreId;
    private double prezzoFinale;
    private List<Articolo> articoli;
    private double offertaMassima;

    // Costruttori
    public Asta() {}

    public Asta(double prezzoIniziale, int rialzoMinimo, LocalDateTime scadenza, int venditoreId) {
        this.prezzoIniziale = prezzoIniziale;
        this.rialzoMinimo = rialzoMinimo;
        this.scadenza = scadenza;
        this.venditoreId = venditoreId;
        this.chiusa = false;
    }

    // Getter e Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getPrezzoIniziale() { return prezzoIniziale; }
    public void setPrezzoIniziale(double prezzoIniziale) { this.prezzoIniziale = prezzoIniziale; }

    public int getRialzoMinimo() { return rialzoMinimo; }
    public void setRialzoMinimo(int rialzoMinimo) { this.rialzoMinimo = rialzoMinimo; }

    public LocalDateTime getScadenza() { return scadenza; }
    public void setScadenza(LocalDateTime scadenza) { this.scadenza = scadenza; }

    public boolean isChiusa() { return chiusa; }
    public void setChiusa(boolean chiusa) { this.chiusa = chiusa; }

    public int getVenditoreId() { return venditoreId; }
    public void setVenditoreId(int venditoreId) { this.venditoreId = venditoreId; }

    public Integer getVincitoreId() { return vincitoreId; }
    public void setVincitoreId(Integer vincitoreId) { this.vincitoreId = vincitoreId; }

    public double getPrezzoFinale() { return prezzoFinale; }
    public void setPrezzoFinale(double prezzoFinale) { this.prezzoFinale = prezzoFinale; }

    public List<Articolo> getArticoli() { return articoli; }
    public void setArticoli(List<Articolo> articoli) { this.articoli = articoli; }

    public double getOffertaMassima() { return offertaMassima; }
    public void setOffertaMassima(double offertaMassima) { this.offertaMassima = offertaMassima; }

    public boolean isScaduta() {
        return LocalDateTime.now().isAfter(scadenza);
    }
}