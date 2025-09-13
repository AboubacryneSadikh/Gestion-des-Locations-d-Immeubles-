package com.example.geslocation.dao;

import com.example.geslocation.model.Utilisateur;
import java.util.Optional;

/**
 * Interface DAO pour les opérations spécifiques aux utilisateurs.
 */
public interface UtilisateurDAO extends GenericDAO<Utilisateur, Long> {
    
    /**
     * Trouve un utilisateur par son email.
     * @param email L'email de l'utilisateur
     * @return Un Optional contenant l'utilisateur si trouvé, sinon un Optional vide
     */
    Optional<Utilisateur> findByEmail(String email);
    
    /**
     * Authentifie un utilisateur avec son email et mot de passe.
     * @param email L'email de l'utilisateur
     * @param motDePasse Le mot de passe de l'utilisateur
     * @return Un Optional contenant l'utilisateur si l'authentification réussit, sinon un Optional vide
     */
    Optional<Utilisateur> authenticate(String email, String motDePasse);
    
    /**
     * Met à jour la dernière date de connexion de l'utilisateur.
     * @param utilisateurId L'ID de l'utilisateur
     * @return true si la mise à jour a réussi, false sinon
     */
    boolean updateLastLogin(Long utilisateurId);
    
    /**
     * Trouve tous les utilisateurs par rôle.
     * @param role Le rôle des utilisateurs à trouver
     * @return Une liste des utilisateurs ayant le rôle spécifié
     */
    java.util.List<Utilisateur> findByRole(Utilisateur.Role role);
}