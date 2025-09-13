package com.example.geslocation.service;

import com.example.geslocation.model.UniteLocation;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux unités de location.
 */
public interface UniteLocationService {
    
    /**
     * Crée une nouvelle unité de location.
     * @param unite L'unité de location à créer
     * @param immeubleId L'ID de l'immeuble auquel l'unité appartient
     * @return L'unité de location créée avec son ID généré
     * @throws Exception Si la création échoue
     */
    UniteLocation creer(UniteLocation unite, Long immeubleId) throws Exception;
    
    /**
     * Récupère une unité de location par son ID.
     * @param id L'ID de l'unité de location
     * @return Un Optional contenant l'unité de location si trouvée, sinon un Optional vide
     */
    Optional<UniteLocation> obtenirParId(Long id);
    
    /**
     * Met à jour les informations d'une unité de location.
     * @param unite L'unité de location avec les informations mises à jour
     * @return L'unité de location mise à jour
     * @throws Exception Si la mise à jour échoue
     */
    UniteLocation mettreAJour(UniteLocation unite) throws Exception;
    
    /**
     * Supprime une unité de location.
     * @param id L'ID de l'unité de location
     * @return true si la suppression a réussi, false sinon
     */
    boolean supprimer(Long id);
    
    /**
     * Récupère toutes les unités de location.
     * @return Une liste de toutes les unités de location
     */
    List<UniteLocation> obtenirToutes();
    
    /**
     * Récupère toutes les unités de location d'un immeuble.
     * @param immeubleId L'ID de l'immeuble
     * @return Une liste des unités de location de l'immeuble
     */
    List<UniteLocation> obtenirParImmeuble(Long immeubleId);
    
    /**
     * Récupère toutes les unités de location disponibles.
     * @return Une liste des unités de location disponibles
     */
    List<UniteLocation> obtenirDisponibles();
    
    /**
     * Récupère toutes les unités de location avec un nombre minimum de pièces.
     * @param nombreMinPieces Le nombre minimum de pièces
     * @return Une liste des unités de location ayant au moins le nombre spécifié de pièces
     */
    List<UniteLocation> obtenirParNombreMinPieces(Integer nombreMinPieces);
    
    /**
     * Récupère toutes les unités de location dans une plage de loyer.
     * @param loyerMin Le loyer minimum
     * @param loyerMax Le loyer maximum
     * @return Une liste des unités de location dont le loyer est dans la plage spécifiée
     */
    List<UniteLocation> obtenirParPlageLoyer(BigDecimal loyerMin, BigDecimal loyerMax);
    
    /**
     * Met à jour le statut d'une unité de location.
     * @param uniteId L'ID de l'unité de location
     * @param statut Le nouveau statut
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean mettreAJourStatut(Long uniteId, UniteLocation.Statut statut);
    
    /**
     * Recherche des unités de location par critères.
     * @param immeubleId L'ID de l'immeuble (peut être null)
     * @param nombreMinPieces Le nombre minimum de pièces (peut être null)
     * @param loyerMin Le loyer minimum (peut être null)
     * @param loyerMax Le loyer maximum (peut être null)
     * @param disponible Si true, ne retourne que les unités disponibles
     * @return Une liste des unités de location correspondant aux critères
     */
    List<UniteLocation> rechercher(Long immeubleId, Integer nombreMinPieces, 
                                  BigDecimal loyerMin, BigDecimal loyerMax, 
                                  Boolean disponible);
}