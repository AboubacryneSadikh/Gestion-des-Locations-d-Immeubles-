package com.example.geslocation.dao;

import com.example.geslocation.model.Immeuble;
import com.example.geslocation.model.Utilisateur;
import java.util.List;

/**
 * Interface DAO pour les opérations spécifiques aux immeubles.
 */
public interface ImmeubleDAO extends GenericDAO<Immeuble, Long> {
    
    /**
     * Trouve tous les immeubles appartenant à un propriétaire.
     * @param proprietaireId L'ID du propriétaire
     * @return Une liste des immeubles appartenant au propriétaire
     */
    List<Immeuble> findByProprietaire(Long proprietaireId);
    
    /**
     * Trouve tous les immeubles dans une ville spécifique.
     * @param ville La ville où se trouvent les immeubles
     * @return Une liste des immeubles dans la ville spécifiée
     */
    List<Immeuble> findByVille(String ville);
    
    /**
     * Trouve tous les immeubles avec un nombre minimum d'unités.
     * @param nombreMinUnites Le nombre minimum d'unités
     * @return Une liste des immeubles ayant au moins le nombre spécifié d'unités
     */
    List<Immeuble> findByNombreMinUnites(Integer nombreMinUnites);
    
    /**
     * Compte le nombre total d'unités pour un propriétaire.
     * @param proprietaireId L'ID du propriétaire
     * @return Le nombre total d'unités appartenant au propriétaire
     */
    Long countUnitesForProprietaire(Long proprietaireId);
    
    /**
     * Recherche des immeubles par critères multiples.
     * @param ville La ville (peut être null)
     * @param nombreMinPieces Le nombre minimum de pièces (peut être null)
     * @param loyerMin Le loyer minimum (peut être null)
     * @param loyerMax Le loyer maximum (peut être null)
     * @return Une liste des immeubles correspondant aux critères
     */
    List<Immeuble> searchByCriteria(String ville, Integer nombreMinPieces, Double loyerMin, Double loyerMax);
}