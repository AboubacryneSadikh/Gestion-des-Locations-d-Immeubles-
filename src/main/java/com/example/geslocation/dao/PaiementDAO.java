package com.example.geslocation.dao;

import com.example.geslocation.model.Paiement;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Interface DAO pour les opérations spécifiques aux paiements.
 */
public interface PaiementDAO extends GenericDAO<Paiement, Long> {
    
    /**
     * Trouve tous les paiements d'un contrat de location.
     * @param contratId L'ID du contrat de location
     * @return Une liste des paiements du contrat
     */
    List<Paiement> findByContrat(Long contratId);
    
    /**
     * Trouve tous les paiements en attente.
     * @return Une liste des paiements en attente
     */
    List<Paiement> findAllPending();
    
    /**
     * Trouve tous les paiements en retard.
     * @return Une liste des paiements en retard
     */
    List<Paiement> findAllLate();
    
    /**
     * Trouve tous les paiements effectués entre deux dates.
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return Une liste des paiements effectués entre les dates spécifiées
     */
    List<Paiement> findByPaymentDateRange(Date dateDebut, Date dateFin);
    
    /**
     * Trouve tous les paiements dont l'échéance est entre deux dates.
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return Une liste des paiements dont l'échéance est entre les dates spécifiées
     */
    List<Paiement> findByDueDateRange(Date dateDebut, Date dateFin);
    
    /**
     * Met à jour le statut d'un paiement.
     * @param paiementId L'ID du paiement
     * @param statut Le nouveau statut
     * @param datePaiement La date de paiement (si le statut est PAYE)
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean updateStatut(Long paiementId, Paiement.Statut statut, Date datePaiement);
    
    /**
     * Marque un paiement comme payé.
     * @param paiementId L'ID du paiement
     * @param datePaiement La date de paiement
     * @param methodePaiement La méthode de paiement
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean markAsPaid(Long paiementId, Date datePaiement, String methodePaiement);
    
    /**
     * Génère un reçu pour un paiement.
     * @param paiementId L'ID du paiement
     * @return true si la génération a réussi, false sinon
     */
    boolean generateReceipt(Long paiementId);
    
    /**
     * Envoie une relance pour un paiement en retard.
     * @param paiementId L'ID du paiement
     * @return true si l'envoi a réussi, false sinon
     */
    boolean sendReminder(Long paiementId);
    
    /**
     * Calcule le montant total des paiements pour un contrat.
     * @param contratId L'ID du contrat
     * @return Le montant total des paiements
     */
    BigDecimal calculateTotalPaymentsForContract(Long contratId);
    
    /**
     * Recherche des paiements par critères multiples.
     * @param contratId L'ID du contrat (peut être null)
     * @param statut Le statut du paiement (peut être null)
     * @param dateEcheanceMin La date d'échéance minimum (peut être null)
     * @param dateEcheanceMax La date d'échéance maximum (peut être null)
     * @param montantMin Le montant minimum (peut être null)
     * @param montantMax Le montant maximum (peut être null)
     * @return Une liste des paiements correspondant aux critères
     */
    List<Paiement> searchByCriteria(Long contratId, Paiement.Statut statut, 
                                   Date dateEcheanceMin, Date dateEcheanceMax, 
                                   BigDecimal montantMin, BigDecimal montantMax);
}