package com.example.geslocation.service;

import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Paiement;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux contrats de location.
 */
public interface ContratLocationService {
    
    /**
     * Crée un nouveau contrat de location.
     * @param contrat Le contrat à créer
     * @param locataireId L'ID du locataire
     * @param uniteId L'ID de l'unité de location
     * @return Le contrat créé avec son ID généré
     * @throws Exception Si la création échoue
     */
    ContratLocation creer(ContratLocation contrat, Long locataireId, Long uniteId) throws Exception;
    
    /**
     * Récupère un contrat de location par son ID.
     * @param id L'ID du contrat
     * @return Un Optional contenant le contrat si trouvé, sinon un Optional vide
     */
    Optional<ContratLocation> obtenirParId(Long id);
    
    /**
     * Met à jour les informations d'un contrat de location.
     * @param contrat Le contrat avec les informations mises à jour
     * @return Le contrat mis à jour
     * @throws Exception Si la mise à jour échoue
     */
    ContratLocation mettreAJour(ContratLocation contrat) throws Exception;
    
    /**
     * Supprime un contrat de location.
     * @param id L'ID du contrat
     * @return true si la suppression a réussi, false sinon
     */
    boolean supprimer(Long id);
    
    /**
     * Récupère tous les contrats de location.
     * @return Une liste de tous les contrats
     */
    List<ContratLocation> obtenirTous();
    
    /**
     * Récupère tous les contrats de location d'un locataire.
     * @param locataireId L'ID du locataire
     * @return Une liste des contrats du locataire
     */
    List<ContratLocation> obtenirParLocataire(Long locataireId);
    
    /**
     * Récupère tous les contrats de location d'une unité de location.
     * @param uniteId L'ID de l'unité de location
     * @return Une liste des contrats de l'unité
     */
    List<ContratLocation> obtenirParUnite(Long uniteId);
    
    /**
     * Récupère tous les contrats de location actifs (en cours).
     * @return Une liste des contrats actifs
     */
    List<ContratLocation> obtenirActifs();
    
    /**
     * Récupère tous les contrats de location qui expirent dans un nombre de jours donné.
     * @param jours Le nombre de jours avant expiration
     * @return Une liste des contrats qui expirent dans le nombre de jours spécifié
     */
    List<ContratLocation> obtenirExpirantDansJours(int jours);
    
    /**
     * Met à jour le statut d'un contrat de location.
     * @param contratId L'ID du contrat
     * @param statut Le nouveau statut
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean mettreAJourStatut(Long contratId, ContratLocation.Statut statut);
    
    /**
     * Renouvelle un contrat de location pour une période donnée.
     * @param contratId L'ID du contrat
     * @param nouvelleDateFin La nouvelle date de fin
     * @param nouveauLoyer Le nouveau loyer (peut être null pour conserver le loyer actuel)
     * @return Le contrat renouvelé
     * @throws Exception Si le renouvellement échoue
     */
    ContratLocation renouveler(Long contratId, Date nouvelleDateFin, BigDecimal nouveauLoyer) throws Exception;
    
    /**
     * Résilie un contrat de location.
     * @param contratId L'ID du contrat
     * @param dateResiliation La date de résiliation
     * @return true si la résiliation a réussi, false sinon
     */

    boolean resilier(Long contratId, Date dateResiliation, String motif, String commentaire);

    /**
     * Génère les paiements mensuels pour un contrat.
     * @param contratId L'ID du contrat
     * @param dateDebut La date de début pour la génération des paiements
     * @param dateFin La date de fin pour la génération des paiements
     * @return La liste des paiements générés
     * @throws Exception Si la génération échoue
     */
    List<Paiement> genererPaiements(Long contratId, Date dateDebut, Date dateFin) throws Exception;
    
    /**
     * Recherche des contrats de location par critères.
     * @param locataireId L'ID du locataire (peut être null)
     * @param uniteId L'ID de l'unité de location (peut être null)
     * @param statut Le statut du contrat (peut être null)
     * @param dateDebutMin La date de début minimum (peut être null)
     * @param dateFinMax La date de fin maximum (peut être null)
     * @return Une liste des contrats correspondant aux critères
     */
    List<ContratLocation> rechercher(Long locataireId, Long uniteId, 
                                    ContratLocation.Statut statut, 
                                    Date dateDebutMin, Date dateFinMax);

    ContratLocation creer(ContratLocation contrat) throws Exception;
}