package com.example.geslocation.service;

import com.example.geslocation.model.Locataire;
import com.example.geslocation.model.Utilisateur;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux locataires.
 */
public interface LocataireService {
    
    /**
     * Crée un nouveau locataire avec un utilisateur associé.
     * @param locataire Le locataire à créer
     * @param utilisateur L'utilisateur à associer au locataire
     * @return Le locataire créé avec son ID généré
     * @throws Exception Si la création échoue
     */
    Locataire creer(Locataire locataire, Utilisateur utilisateur) throws Exception;
    
    /**
     * Crée un nouveau locataire avec un utilisateur existant.
     * @param locataire Le locataire à créer
     * @param utilisateurId L'ID de l'utilisateur à associer au locataire
     * @return Le locataire créé avec son ID généré
     * @throws Exception Si la création échoue
     */
    Locataire creerAvecUtilisateurExistant(Locataire locataire, Long utilisateurId) throws Exception;
    
    /**
     * Récupère un locataire par son ID.
     * @param id L'ID du locataire
     * @return Un Optional contenant le locataire si trouvé, sinon un Optional vide
     */
    Optional<Locataire> obtenirParId(Long id);
    
    /**
     * Récupère un locataire par l'ID de son utilisateur associé.
     * @param utilisateurId L'ID de l'utilisateur
     * @return Un Optional contenant le locataire si trouvé, sinon un Optional vide
     */
    Optional<Locataire> obtenirParUtilisateur(Long utilisateurId);
    
    /**
     * Récupère un locataire par l'email de son utilisateur associé.
     * @param email L'email de l'utilisateur
     * @return Un Optional contenant le locataire si trouvé, sinon un Optional vide
     */
    Optional<Locataire> obtenirParEmail(String email);
    
    /**
     * Met à jour les informations d'un locataire.
     * @param locataire Le locataire avec les informations mises à jour
     * @return Le locataire mis à jour
     * @throws Exception Si la mise à jour échoue
     */
    Locataire mettreAJour(Locataire locataire) throws Exception;
    
    /**
     * Supprime un locataire.
     * @param id L'ID du locataire
     * @return true si la suppression a réussi, false sinon
     */
    boolean supprimer(Long id);
    
    /**
     * Récupère tous les locataires.
     * @return Une liste de tous les locataires
     */
    List<Locataire> obtenirTous();
    
    /**
     * Récupère tous les locataires avec un revenu mensuel minimum.
     * @param revenuMin Le revenu mensuel minimum
     * @return Une liste des locataires ayant au moins le revenu spécifié
     */
    List<Locataire> obtenirParRevenuMin(Double revenuMin);
    
    /**
     * Recherche des locataires par critères.
     * @param nom Le nom (peut être null)
     * @param prenom Le prénom (peut être null)
     * @param revenuMin Le revenu mensuel minimum (peut être null)
     * @return Une liste des locataires correspondant aux critères
     */
    List<Locataire> rechercher(String nom, String prenom, Double revenuMin);
    
    /**
     * Vérifie si un locataire est éligible pour louer une unité.
     * @param locataireId L'ID du locataire
     * @param loyerMensuel Le loyer mensuel de l'unité
     * @return true si le locataire est éligible, false sinon
     */
    boolean estEligiblePourLocation(Long locataireId, Double loyerMensuel);
}