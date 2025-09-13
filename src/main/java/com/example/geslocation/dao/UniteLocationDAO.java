package com.example.geslocation.dao;

import com.example.geslocation.model.UniteLocation;
import java.math.BigDecimal;
import java.util.List;

/**
 * Interface DAO pour les opérations spécifiques aux unités de location.
 */
public interface UniteLocationDAO extends GenericDAO<UniteLocation, Long> {
    
    /**
     * Trouve toutes les unités de location d'un immeuble.
     * @param immeubleId L'ID de l'immeuble
     * @return Une liste des unités de location de l'immeuble
     */
    List<UniteLocation> findByImmeuble(Long immeubleId);
    
    /**
     * Trouve toutes les unités de location disponibles.
     * @return Une liste des unités de location disponibles
     */
    List<UniteLocation> findAllAvailable();
    
    /**
     * Trouve toutes les unités de location avec un nombre minimum de pièces.
     * @param nombreMinPieces Le nombre minimum de pièces
     * @return Une liste des unités de location ayant au moins le nombre spécifié de pièces
     */
    List<UniteLocation> findByNombreMinPieces(Integer nombreMinPieces);
    
    /**
     * Trouve toutes les unités de location dans une plage de loyer.
     * @param loyerMin Le loyer minimum
     * @param loyerMax Le loyer maximum
     * @return Une liste des unités de location dont le loyer est dans la plage spécifiée
     */
    List<UniteLocation> findByLoyerRange(BigDecimal loyerMin, BigDecimal loyerMax);
    
    /**
     * Recherche des unités de location par critères multiples.
     * @param immeubleId L'ID de l'immeuble (peut être null)
     * @param nombreMinPieces Le nombre minimum de pièces (peut être null)
     * @param loyerMin Le loyer minimum (peut être null)
     * @param loyerMax Le loyer maximum (peut être null)
     * @param disponible Si true, ne retourne que les unités disponibles
     * @return Une liste des unités de location correspondant aux critères
     */
    List<UniteLocation> searchByCriteria(Long immeubleId, Integer nombreMinPieces, 
                                        BigDecimal loyerMin, BigDecimal loyerMax, 
                                        Boolean disponible);
    
    /**
     * Met à jour le statut d'une unité de location.
     * @param uniteId L'ID de l'unité de location
     * @param statut Le nouveau statut
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean updateStatut(Long uniteId, UniteLocation.Statut statut);
}