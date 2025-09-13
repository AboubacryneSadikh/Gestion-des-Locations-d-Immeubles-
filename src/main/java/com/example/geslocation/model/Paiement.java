package com.example.geslocation.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "paiements")
public class Paiement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_reference", nullable = false, unique = true, length = 50)
    private String numeroReference;

    @ManyToOne
    @JoinColumn(name = "contrat_id", nullable = false)
    private ContratLocation contrat;

    @Column(nullable = false)
    private BigDecimal montant;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_echeance", nullable = false)
    private Date dateEcheance;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_paiement")
    private Date datePaiement;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Statut statut = Statut.EN_ATTENTE;

    // CORRECTION: Renommé de methodePaiement à modePaiement pour cohérence
    @Column(name = "mode_paiement", length = 50)
    private String modePaiement;

    // AJOUT: Type de paiement (LOYER, CHARGES, DEPOT, etc.)
    @Column(name = "type_paiement", length = 50)
    private String typePaiement;

    // AJOUT: Description du paiement
    @Column(length = 500)
    private String description;

    // CORRECTION: Renommé de notes à commentaires pour cohérence
    @Column(length = 1000)
    private String commentaires;

    @Column(name = "recu_genere")
    private boolean recuGenere = false;

    @Column(name = "relance_envoyee")
    private boolean relanceEnvoyee = false;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation", nullable = false)
    private Date dateCreation;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_modification")
    private Date dateModification;

    // Enum pour le statut du paiement
    public enum Statut {
        EN_ATTENTE, PAYE, EN_RETARD, ANNULE
    }

    // Constructeurs
    public Paiement() {
        this.dateCreation = new Date();
    }

    public Paiement(String numeroReference, ContratLocation contrat, BigDecimal montant, Date dateEcheance) {
        this();
        this.numeroReference = numeroReference;
        this.contrat = contrat;
        this.montant = montant;
        this.dateEcheance = dateEcheance;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNumeroReference() {
        return numeroReference;
    }

    public void setNumeroReference(String numeroReference) {
        this.numeroReference = numeroReference;
    }

    public ContratLocation getContrat() {
        return contrat;
    }

    public void setContrat(ContratLocation contrat) {
        this.contrat = contrat;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public Date getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(Date datePaiement) {
        this.datePaiement = datePaiement;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    // CORRECTION: Getter/Setter pour modePaiement au lieu de methodePaiement
    public String getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(String modePaiement) {
        this.modePaiement = modePaiement;
    }

    // CONSERVATION: Méthodes pour compatibilité avec l'ancien nom
    @Deprecated
    public String getMethodePaiement() {
        return modePaiement;
    }

    @Deprecated
    public void setMethodePaiement(String methodePaiement) {
        this.modePaiement = methodePaiement;
    }

    // AJOUT: Getter/Setter pour typePaiement
    public String getTypePaiement() {
        return typePaiement;
    }

    public void setTypePaiement(String typePaiement) {
        this.typePaiement = typePaiement;
    }

    // AJOUT: Getter/Setter pour description
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // CORRECTION: Getter/Setter pour commentaires au lieu de notes
    public String getCommentaires() {
        return commentaires;
    }

    public void setCommentaires(String commentaires) {
        this.commentaires = commentaires;
    }

    // CONSERVATION: Méthodes pour compatibilité avec l'ancien nom
    @Deprecated
    public String getNotes() {
        return commentaires;
    }

    @Deprecated
    public void setNotes(String notes) {
        this.commentaires = notes;
    }

    public boolean isRecuGenere() {
        return recuGenere;
    }

    public void setRecuGenere(boolean recuGenere) {
        this.recuGenere = recuGenere;
    }

    public boolean isRelanceEnvoyee() {
        return relanceEnvoyee;
    }

    public void setRelanceEnvoyee(boolean relanceEnvoyee) {
        this.relanceEnvoyee = relanceEnvoyee;
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

    /**
     * Vérifie si le paiement est en retard par rapport à la date actuelle.
     * @return true si le paiement est en retard
     */
    public boolean isEnRetard() {
        return this.statut == Statut.EN_ATTENTE &&
                this.dateEcheance.before(new Date());
    }

    /**
     * Calcule le nombre de jours de retard.
     * @return le nombre de jours de retard (0 si pas en retard)
     */
    public long getJoursDeRetard() {
        if (!isEnRetard()) {
            return 0;
        }
        long diff = new Date().getTime() - this.dateEcheance.getTime();
        return diff / (1000 * 60 * 60 * 24);
    }

    /**
     * Calcule le nombre de jours jusqu'à l'échéance.
     * @return le nombre de jours (négatif si déjà passé)
     */
    public long getJoursJusquEcheance() {
        long diff = this.dateEcheance.getTime() - new Date().getTime();
        return diff / (1000 * 60 * 60 * 24);
    }

    @Override
    public String toString() {
        return "Paiement{" +
                "id=" + id +
                ", numeroReference='" + numeroReference + '\'' +
                ", contrat=" + (contrat != null ? contrat.getId() : null) +
                ", montant=" + montant +
                ", dateEcheance=" + dateEcheance +
                ", datePaiement=" + datePaiement +
                ", statut=" + statut +
                ", modePaiement='" + modePaiement + '\'' +
                ", typePaiement='" + typePaiement + '\'' +
                '}';
    }
}