package com.example.geslocation.dao;

import com.example.geslocation.model.Locataire;
import com.example.geslocation.model.Utilisateur;
import java.util.List;
import java.util.Optional;

/**
 * Interface DAO pour les opérations spécifiques aux locataires.
 */
public interface LocataireDAO extends GenericDAO<Locataire, Long> {
    
    /**
     * Trouve un locataire par l'ID de son utilisateur associé.
     * @param utilisateurId L'ID de l'utilisateur
     * @return Un Optional contenant le locataire si trouvé, sinon un Optional vide
     */
    Optional<Locataire> findByUtilisateur(Long utilisateurId);
    
    /**
     * Trouve un locataire par l'email de son utilisateur associé.
     * @param email L'email de l'utilisateur
     * @return Un Optional contenant le locataire si trouvé, sinon un Optional vide
     */
    Optional<Locataire> findByEmail(String email);
    
    /**
     * Trouve tous les locataires avec un revenu mensuel minimum.
     * @param revenuMin Le revenu mensuel minimum
     * @return Une liste des locataires ayant au moins le revenu spécifié
     */
    List<Locataire> findByRevenuMin(Double revenuMin);
    
    /**
     * Crée un nouveau locataire avec un utilisateur associé.
     * @param locataire Le locataire à créer
     * @param utilisateur L'utilisateur à associer au locataire
     * @return Le locataire créé avec son ID généré
     */
    Locataire createWithUtilisateur(Locataire locataire, Utilisateur utilisateur);
    
    /**
     * Recherche des locataires par critères multiples.
     * @param nom Le nom (peut être null)
     * @param prenom Le prénom (peut être null)
     * @param revenuMin Le revenu mensuel minimum (peut être null)
     * @return Une liste des locataires correspondant aux critères
     */
    List<Locataire> searchByCriteria(String nom, String prenom, Double revenuMin);
}