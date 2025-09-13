package com.example.geslocation.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "candidatures_location")
public class CandidatureLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "locataire_id", nullable = false)
    private Locataire locataire;

    @ManyToOne
    @JoinColumn(name = "unite_id", nullable = false)
    private UniteLocation unite;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_debut_souhaitee", nullable = false)
    private Date dateDebutSouhaitee;

    @Column(name = "duree_bail", nullable = false)
    private Integer dureeBail; // en mois

    @Column(length = 2000)
    private String motivations;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Statut statut = Statut.EN_ATTENTE;

    @Column(length = 1000)
    private String commentaireProprietaire;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_reponse")
    private Date dateReponse;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;

    public enum Statut {
        EN_ATTENTE("En attente de traitement"),
        APPROUVEE("Candidature approuvée"),
        REFUSEE("Candidature refusée"),
        ANNULEE("Candidature annulée"),
        CONTRAT_SIGNE("Contrat signé");

        private final String libelle;

        Statut(String libelle) {
            this.libelle = libelle;
        }

        public String getLibelle() {
            return libelle;
        }
    }

    // Constructeurs
    public CandidatureLocation() {
        this.dateCreation = new Date();
    }

    public CandidatureLocation(Locataire locataire, UniteLocation unite,
                               Date dateDebutSouhaitee, Integer dureeBail) {
        this();
        this.locataire = locataire;
        this.unite = unite;
        this.dateDebutSouhaitee = dateDebutSouhaitee;
        this.dureeBail = dureeBail;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Date getDateDebutSouhaitee() {
        return dateDebutSouhaitee;
    }

    public void setDateDebutSouhaitee(Date dateDebutSouhaitee) {
        this.dateDebutSouhaitee = dateDebutSouhaitee;
    }

    public Integer getDureeBail() {
        return dureeBail;
    }

    public void setDureeBail(Integer dureeBail) {
        this.dureeBail = dureeBail;
    }

    public String getMotivations() {
        return motivations;
    }

    public void setMotivations(String motivations) {
        this.motivations = motivations;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public String getCommentaireProprietaire() {
        return commentaireProprietaire;
    }

    public void setCommentaireProprietaire(String commentaireProprietaire) {
        this.commentaireProprietaire = commentaireProprietaire;
    }

    public Date getDateReponse() {
        return dateReponse;
    }

    public void setDateReponse(Date dateReponse) {
        this.dateReponse = dateReponse;
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

    @PreUpdate
    protected void onUpdate() {
        this.dateModification = new Date();
    }

    @Override
    public String toString() {
        return "CandidatureLocation{" +
                "id=" + id +
                ", locataire=" + (locataire != null ? locataire.getId() : null) +
                ", unite=" + (unite != null ? unite.getId() : null) +
                ", dateDebutSouhaitee=" + dateDebutSouhaitee +
                ", statut=" + statut +
                ", dateCreation=" + dateCreation +
                '}';
    }
}