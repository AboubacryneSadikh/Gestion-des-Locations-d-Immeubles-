package com.example.geslocation.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "unites_location")
public class UniteLocation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 20)
    private String numero;
    
    @Column(name = "nombre_pieces", nullable = false)
    private Integer nombrePieces;
    
    @Column(nullable = false)
    private BigDecimal superficie;
    
    @Column(nullable = false)
    private BigDecimal loyer;
    
    @Column(name = "charges_mensuelles")
    private BigDecimal chargesMensuelles;
    
    @Column(name = "depot_garantie")
    private BigDecimal depotGarantie;
    
    @Column(nullable = false)
    private Integer etage;
    
    @Column(length = 1000)
    private String description;
    
    @Column(length = 1000)
    private String equipements;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Statut statut = Statut.DISPONIBLE;
    
    @ManyToOne
    @JoinColumn(name = "immeuble_id", nullable = false)
    private Immeuble immeuble;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;
    
    @Column(nullable = false)
    private boolean actif = true;
    
    // Enum pour le statut de l'unité
    public enum Statut {
        DISPONIBLE, LOUE, EN_MAINTENANCE, RESERVE
    }
    
    // Constructeurs
    public UniteLocation() {
        this.dateCreation = new Date();
    }
    
    public UniteLocation(String numero, Integer nombrePieces, BigDecimal superficie, BigDecimal loyer, Integer etage, Immeuble immeuble) {
        this();
        this.numero = numero;
        this.nombrePieces = nombrePieces;
        this.superficie = superficie;
        this.loyer = loyer;
        this.etage = etage;
        this.immeuble = immeuble;
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public Integer getNombrePieces() {
        return nombrePieces;
    }

    public void setNombrePieces(Integer nombrePieces) {
        this.nombrePieces = nombrePieces;
    }

    public BigDecimal getSuperficie() {
        return superficie;
    }

    public void setSuperficie(BigDecimal superficie) {
        this.superficie = superficie;
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

    public Integer getEtage() {
        return etage;
    }

    public void setEtage(Integer etage) {
        this.etage = etage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getEquipements() {
        return equipements;
    }

    public void setEquipements(String equipements) {
        this.equipements = equipements;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public Immeuble getImmeuble() {
        return immeuble;
    }

    public void setImmeuble(Immeuble immeuble) {
        this.immeuble = immeuble;
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
        return "UniteLocation{" +
                "id=" + id +
                ", numero='" + numero + '\'' +
                ", nombrePieces=" + nombrePieces +
                ", superficie=" + superficie +
                ", loyer=" + loyer +
                ", statut=" + statut +
                ", immeuble=" + (immeuble != null ? immeuble.getId() : null) +
                '}';
    }
}