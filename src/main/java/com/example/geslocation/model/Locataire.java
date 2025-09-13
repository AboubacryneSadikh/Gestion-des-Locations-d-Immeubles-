package com.example.geslocation.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "locataires")
public class Locataire {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne
    @JoinColumn(name = "utilisateur_id", nullable = false, unique = true)
    private Utilisateur utilisateur;
    
    @Column(name = "numero_identification", length = 50)
    private String numeroIdentification;
    
    @Column(name = "profession", length = 100)
    private String profession;
    
    @Column(name = "revenu_mensuel")
    private Double revenuMensuel;
    
    @Column(name = "employeur", length = 100)
    private String employeur;
    
    @Column(name = "telephone_employeur", length = 15)
    private String telephoneEmployeur;
    
    @Column(name = "adresse_employeur", length = 255)
    private String adresseEmployeur;
    
    @Column(name = "contact_urgence_nom", length = 100)
    private String contactUrgenceNom;
    
    @Column(name = "contact_urgence_telephone", length = 15)
    private String contactUrgenceTelephone;
    
    @Column(name = "contact_urgence_relation", length = 50)
    private String contactUrgenceRelation;
    
    @OneToMany(mappedBy = "locataire", cascade = CascadeType.ALL)
    private List<ContratLocation> contrats = new ArrayList<>();
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;
    
    @Column(nullable = false)
    private boolean actif = true;
    
    // Constructeurs
    public Locataire() {
        this.dateCreation = new Date();
    }
    
    public Locataire(Utilisateur utilisateur) {
        this();
        this.utilisateur = utilisateur;
    }
    
    // Méthodes pour gérer la relation bidirectionnelle avec ContratLocation
    public void addContrat(ContratLocation contrat) {
        contrats.add(contrat);
        contrat.setLocataire(this);
    }
    
    public void removeContrat(ContratLocation contrat) {
        contrats.remove(contrat);
        contrat.setLocataire(null);
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public String getNumeroIdentification() {
        return numeroIdentification;
    }

    public void setNumeroIdentification(String numeroIdentification) {
        this.numeroIdentification = numeroIdentification;
    }

    public String getProfession() {
        return profession;
    }

    public void setProfession(String profession) {
        this.profession = profession;
    }

    public Double getRevenuMensuel() {
        return revenuMensuel;
    }

    public void setRevenuMensuel(Double revenuMensuel) {
        this.revenuMensuel = revenuMensuel;
    }

    public String getEmployeur() {
        return employeur;
    }

    public void setEmployeur(String employeur) {
        this.employeur = employeur;
    }

    public String getTelephoneEmployeur() {
        return telephoneEmployeur;
    }

    public void setTelephoneEmployeur(String telephoneEmployeur) {
        this.telephoneEmployeur = telephoneEmployeur;
    }

    public String getAdresseEmployeur() {
        return adresseEmployeur;
    }

    public void setAdresseEmployeur(String adresseEmployeur) {
        this.adresseEmployeur = adresseEmployeur;
    }

    public String getContactUrgenceNom() {
        return contactUrgenceNom;
    }

    public void setContactUrgenceNom(String contactUrgenceNom) {
        this.contactUrgenceNom = contactUrgenceNom;
    }

    public String getContactUrgenceTelephone() {
        return contactUrgenceTelephone;
    }

    public void setContactUrgenceTelephone(String contactUrgenceTelephone) {
        this.contactUrgenceTelephone = contactUrgenceTelephone;
    }

    public String getContactUrgenceRelation() {
        return contactUrgenceRelation;
    }

    public void setContactUrgenceRelation(String contactUrgenceRelation) {
        this.contactUrgenceRelation = contactUrgenceRelation;
    }

    public List<ContratLocation> getContrats() {
        return contrats;
    }

    public void setContrats(List<ContratLocation> contrats) {
        this.contrats = contrats;
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
        return "Locataire{" +
                "id=" + id +
                ", utilisateur=" + (utilisateur != null ? utilisateur.getId() : null) +
                ", numeroIdentification='" + numeroIdentification + '\'' +
                ", profession='" + profession + '\'' +
                ", revenuMensuel=" + revenuMensuel +
                '}';
    }
}