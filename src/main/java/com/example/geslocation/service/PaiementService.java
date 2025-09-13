package com.example.geslocation.service;

import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Paiement;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux paiements.
 */
public interface PaiementService {
    
    /**
     * Crée un nouveau paiement.
     * @param paiement Le paiement à créer
     * @param contratId L'ID du contrat associé au paiement
     * @return Le paiement créé avec son ID généré
     * @throws Exception Si la création échoue
     */

    Paiement creer(Paiement paiement) throws Exception;

    /**
     * Récupère un paiement par son ID.
     * @param id L'ID du paiement
     * @return Un Optional contenant le paiement si trouvé, sinon un Optional vide
     */
    Optional<Paiement> obtenirParId(Long id);
    
    /**
     * Met à jour les informations d'un paiement.
     * @param paiement Le paiement avec les informations mises à jour
     * @return Le paiement mis à jour
     * @throws Exception Si la mise à jour échoue
     */
    Paiement mettreAJour(Paiement paiement) throws Exception;
    
    /**
     * Supprime un paiement.
     * @param id L'ID du paiement
     * @return true si la suppression a réussi, false sinon
     */
    boolean supprimer(Long id);
    
    /**
     * Récupère tous les paiements.
     * @return Une liste de tous les paiements
     */
    List<Paiement> obtenirTous();
    
    /**
     * Récupère tous les paiements d'un contrat.
     * @param contratId L'ID du contrat
     * @return Une liste des paiements du contrat
     */
    List<Paiement> obtenirParContrat(Long contratId);
    
    /**
     * Récupère tous les paiements en attente.
     * @return Une liste des paiements en attente
     */
    List<Paiement> obtenirEnAttente();
    
    /**
     * Récupère tous les paiements en retard.
     * @return Une liste des paiements en retard
     */
    List<Paiement> obtenirEnRetard();
    
    /**
     * Récupère tous les paiements effectués entre deux dates.
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return Une liste des paiements effectués entre les dates spécifiées
     */
    List<Paiement> obtenirParDatePaiement(Date dateDebut, Date dateFin);
    
    /**
     * Récupère tous les paiements dont l'échéance est entre deux dates.
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return Une liste des paiements dont l'échéance est entre les dates spécifiées
     */
    List<Paiement> obtenirParDateEcheance(Date dateDebut, Date dateFin);
    
    /**
     * Marque un paiement comme payé.
     * @param paiementId L'ID du paiement
     * @param datePaiement La date de paiement
     * @param methodePaiement La méthode de paiement
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean marquerCommePaye(Long paiementId, Date datePaiement, String methodePaiement);
    
    /**
     * Marque un paiement comme en retard.
     * @param paiementId L'ID du paiement
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean marquerCommeEnRetard(Long paiementId);
    
    /**
     * Génère un reçu pour un paiement.
     * @param paiementId L'ID du paiement
     * @return true si la génération a réussi, false sinon
     */
    boolean genererRecu(Long paiementId);
    
    /**
     * Envoie une relance pour un paiement en retard.
     * @param paiementId L'ID du paiement
     * @return true si l'envoi a réussi, false sinon
     */
    boolean envoyerRelance(Long paiementId);
    
    /**
     * Calcule le montant total des paiements pour un contrat.
     * @param contratId L'ID du contrat
     * @return Le montant total des paiements
     */
    BigDecimal calculerTotalPaiementsContrat(Long contratId);
    
    /**
     * Recherche des paiements par critères.
     * @param contratId L'ID du contrat (peut être null)
     * @param statut Le statut du paiement (peut être null)
     * @param dateEcheanceMin La date d'échéance minimum (peut être null)
     * @param dateEcheanceMax La date d'échéance maximum (peut être null)
     * @param montantMin Le montant minimum (peut être null)
     * @param montantMax Le montant maximum (peut être null)
     * @return Une liste des paiements correspondant aux critères
     */
    List<Paiement> rechercher(Long contratId, Paiement.Statut statut, 
                             Date dateEcheanceMin, Date dateEcheanceMax, 
                             BigDecimal montantMin, BigDecimal montantMax);

    int verifierEtMettreAJourPaiementsEnRetard();

    void genererPaiementsMensuels(ContratLocation contrat);

    boolean paiementExistePourPeriode(Long contratId, Date dateEcheance);

    int supprimerPaiementsEnDouble(Long contratId);

    void mettreAJourStatutsPaiements();

    Paiement creerPaiementImmediat(ContratLocation contrat, String typePaiement) throws Exception;
}