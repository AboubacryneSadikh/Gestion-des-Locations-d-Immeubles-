package com.example.geslocation.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "contrats_location")
public class ContratLocation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "numero_contrat", nullable = false, unique = true, length = 50)
    private String numeroContrat;
    
    @ManyToOne
    @JoinColumn(name = "locataire_id", nullable = false)
    private Locataire locataire;
    
    @ManyToOne
    @JoinColumn(name = "unite_id", nullable = false)
    private UniteLocation unite;
    
    @Temporal(TemporalType.DATE)
    @Column(name = "date_debut", nullable = false)
    private Date dateDebut;
    
    @Temporal(TemporalType.DATE)
    @Column(name = "date_fin", nullable = false)
    private Date dateFin;
    
    @Column(nullable = false)
    private BigDecimal loyer;
    
    @Column(name = "charges_mensuelles")
    private BigDecimal chargesMensuelles;
    
    @Column(name = "depot_garantie")
    private BigDecimal depotGarantie;
    
    @Column(name = "jour_paiement", nullable = false)
    private Integer jourPaiement;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Statut statut = Statut.EN_COURS;
    
    @Column(length = 1000)
    private String conditions;
    
    @OneToMany(mappedBy = "contrat", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Paiement> paiements = new ArrayList<>();
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;
    
    @Column(nullable = false)
    private boolean actif = true;
    
    // Enum pour le statut du contrat
    public enum Statut {
        EN_ATTENTE, EN_COURS, TERMINE, RESILIE, SUSPENDU
    }
    
    // Constructeurs
    public ContratLocation() {
        this.dateCreation = new Date();
    }
    
    public ContratLocation(String numeroContrat, Locataire locataire, UniteLocation unite, 
                          Date dateDebut, Date dateFin, BigDecimal loyer, Integer jourPaiement) {
        this();
        this.numeroContrat = numeroContrat;
        this.locataire = locataire;
        this.unite = unite;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.loyer = loyer;
        this.jourPaiement = jourPaiement;
    }
    
    // Méthodes pour gérer la relation bidirectionnelle avec Paiement
    public void addPaiement(Paiement paiement) {
        paiements.add(paiement);
        paiement.setContrat(this);
    }
    
    public void removePaiement(Paiement paiement) {
        paiements.remove(paiement);
        paiement.setContrat(null);
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNumeroContrat() {
        return numeroContrat;
    }

    public void setNumeroContrat(String numeroContrat) {
        this.numeroContrat = numeroContrat;
    }

    public Locataire getLocataire() {
        return locataire;
    }

    public void setLocataire(Locataire locataire) {
        this.locataire = locataire;
    }

    public UniteLocation getUnite() {
        return unite;
    }

    public void setUnite(UniteLocation unite) {
        this.unite = unite;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public BigDecimal getLoyer() {
        return loyer;
    }

    public void setLoyer(BigDecimal loyer) {
        this.loyer = loyer;
    }

    public BigDecimal getChargesMensuelles() {
        return chargesMensuelles;
    }

    public void setChargesMensuelles(BigDecimal chargesMensuelles) {
        this.chargesMensuelles = chargesMensuelles;
    }

    public BigDecimal getDepotGarantie() {
        return depotGarantie;
    }

    public void setDepotGarantie(BigDecimal depotGarantie) {
        this.depotGarantie = depotGarantie;
    }

    public Integer getJourPaiement() {
        return jourPaiement;
    }

    public void setJourPaiement(Integer jourPaiement) {
        this.jourPaiement = jourPaiement;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public String getConditions() {
        return conditions;
    }

    public void setConditions(String conditions) {
        this.conditions = conditions;
    }

    public List<Paiement> getPaiements() {
        return paiements;
    }

    public void setPaiements(List<Paiement> paiements) {
        this.paiements = paiements;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    public Date getDateModification() {
        return dateModification;
    }

    public void setDateModification(Date dateModification) {
        this.dateModification = dateModification;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.dateModification = new Date();
    }
    
    @Override
    public String toString() {
        return "ContratLocation{" +
                "id=" + id +
                ", numeroContrat='" + numeroContrat + '\'' +
                ", locataire=" + (locataire != null ? locataire.getId() : null) +
                ", unite=" + (unite != null ? unite.getId() : null) +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                ", loyer=" + loyer +
                ", statut=" + statut +
                '}';
    }
}