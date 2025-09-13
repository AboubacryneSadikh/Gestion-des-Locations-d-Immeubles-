package com.example.geslocation.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "immeubles")
public class Immeuble {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String nom;
    
    @Column(nullable = false, length = 255)
    private String adresse;
    
    @Column(length = 50)
    private String ville;
    
    @Column(length = 10)
    private String codePostal;
    
    @Column(length = 50)
    private String pays;
    
    @Column(length = 1000)
    private String description;
    
    @Column(name = "annee_construction")
    private Integer anneeConstruction;
    
    @Column(name = "nombre_etages")
    private Integer nombreEtages;
    
    @Column(name = "nombre_unites")
    private Integer nombreUnites;
    
    @Column(length = 1000)
    private String equipements;
    
    @ManyToOne
    @JoinColumn(name = "proprietaire_id", nullable = false)
    private Utilisateur proprietaire;
    
    @OneToMany(mappedBy = "immeuble", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UniteLocation> unites = new ArrayList<>();
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;
    
    @Column(nullable = false)
    private boolean actif = true;
    
    // Constructeurs
    public Immeuble() {
        this.dateCreation = new Date();
    }
    
    public Immeuble(String nom, String adresse, String ville, String codePostal, Utilisateur proprietaire) {
        this();
        this.nom = nom;
        this.adresse = adresse;
        this.ville = ville;
        this.codePostal = codePostal;
        this.proprietaire = proprietaire;
    }
    
    // Méthodes pour gérer la relation bidirectionnelle avec UniteLocation
    public void addUnite(UniteLocation unite) {
        unites.add(unite);
        unite.setImmeuble(this);
    }
    
    public void removeUnite(UniteLocation unite) {
        unites.remove(unite);
        unite.setImmeuble(null);
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getVille() {
        return ville;
    }

    public void setVille(String ville) {
        this.ville = ville;
    }

    public String getCodePostal() {
        return codePostal;
    }

    public void setCodePostal(String codePostal) {
        this.codePostal = codePostal;
    }

    public String getPays() {
        return pays;
    }

    public void setPays(String pays) {
        this.pays = pays;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getAnneeConstruction() {
        return anneeConstruction;
    }

    public void setAnneeConstruction(Integer anneeConstruction) {
        this.anneeConstruction = anneeConstruction;
    }

    public Integer getNombreEtages() {
        return nombreEtages;
    }

    public void setNombreEtages(Integer nombreEtages) {
        this.nombreEtages = nombreEtages;
    }

    public Integer getNombreUnites() {
        return nombreUnites;
    }

    public void setNombreUnites(Integer nombreUnites) {
        this.nombreUnites = nombreUnites;
    }

    public String getEquipements() {
        return equipements;
    }

    public void setEquipements(String equipements) {
        this.equipements = equipements;
    }

    public Utilisateur getProprietaire() {
        return proprietaire;
    }

    public void setProprietaire(Utilisateur proprietaire) {
        this.proprietaire = proprietaire;
    }

    public List<UniteLocation> getUnites() {
        return unites;
    }

    public void setUnites(List<UniteLocation> unites) {
        this.unites = unites;
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
        return "Immeuble{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", adresse='" + adresse + '\'' +
                ", ville='" + ville + '\'' +
                ", proprietaire=" + (proprietaire != null ? proprietaire.getId() : null) +
                ", nombreUnites=" + nombreUnites +
                '}';
    }
}