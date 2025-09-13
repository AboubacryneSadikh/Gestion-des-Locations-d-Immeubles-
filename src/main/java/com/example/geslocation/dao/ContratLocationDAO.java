package com.example.geslocation.dao;

import com.example.geslocation.model.ContratLocation;
import java.util.Date;
import java.util.List;

/**
 * Interface DAO pour les opérations spécifiques aux contrats de location.
 */
public interface ContratLocationDAO extends GenericDAO<ContratLocation, Long> {
    
    /**
     * Trouve tous les contrats de location d'un locataire.
     * @param locataireId L'ID du locataire
     * @return Une liste des contrats de location du locataire
     */
    List<ContratLocation> findByLocataire(Long locataireId);
    
    /**
     * Trouve tous les contrats de location d'une unité de location.
     * @param uniteId L'ID de l'unité de location
     * @return Une liste des contrats de location de l'unité
     */
    List<ContratLocation> findByUnite(Long uniteId);
    
    /**
     * Trouve tous les contrats de location actifs (en cours).
     * @return Une liste des contrats de location actifs
     */
    List<ContratLocation> findAllActive();
    
    /**
     * Trouve tous les contrats de location qui expirent dans un nombre de jours donné.
     * @param jours Le nombre de jours avant expiration
     * @return Une liste des contrats de location qui expirent dans le nombre de jours spécifié
     */
    List<ContratLocation> findExpiringInDays(int jours);
    
    /**
     * Trouve tous les contrats de location créés entre deux dates.
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return Une liste des contrats de location créés entre les dates spécifiées
     */
    List<ContratLocation> findByCreationDateRange(Date dateDebut, Date dateFin);
    
    /**
     * Met à jour le statut d'un contrat de location.
     * @param contratId L'ID du contrat de location
     * @param statut Le nouveau statut
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean updateStatut(Long contratId, ContratLocation.Statut statut);
    
    /**
     * Recherche des contrats de location par critères multiples.
     * @param locataireId L'ID du locataire (peut être null)
     * @param uniteId L'ID de l'unité de location (peut être null)
     * @param statut Le statut du contrat (peut être null)
     * @param dateDebutMin La date de début minimum (peut être null)
     * @param dateFinMax La date de fin maximum (peut être null)
     * @return Une liste des contrats de location correspondant aux critères
     */
    List<ContratLocation> searchByCriteria(Long locataireId, Long uniteId, 
                                          ContratLocation.Statut statut, 
                                          Date dateDebutMin, Date dateFinMax);
}