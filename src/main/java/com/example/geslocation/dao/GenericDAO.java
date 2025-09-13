package com.example.geslocation.dao;

import java.util.List;
import java.util.Optional;

/**
 * Interface générique pour les opérations DAO de base.
 * @param <T> Le type d'entité
 * @param <ID> Le type de l'identifiant de l'entité
 */
public interface GenericDAO<T, ID> {
    
    /**
     * Persiste une nouvelle entité dans la base de données.
     * @param entity L'entité à persister
     * @return L'entité persistée avec son ID généré
     */
    T create(T entity);
    
    /**
     * Trouve une entité par son identifiant.
     * @param id L'identifiant de l'entité
     * @return Un Optional contenant l'entité si trouvée, sinon un Optional vide
     */
    Optional<T> findById(ID id);
    
    /**
     * Récupère toutes les entités.
     * @return Une liste de toutes les entités
     */
    List<T> findAll();
    
    /**
     * Met à jour une entité existante.
     * @param entity L'entité à mettre à jour
     * @return L'entité mise à jour
     */
    T update(T entity);
    
    /**
     * Supprime une entité par son identifiant.
     * @param id L'identifiant de l'entité à supprimer
     * @return true si l'entité a été supprimée, false sinon
     */
    boolean delete(ID id);
    
    /**
     * Récupère toutes les entités actives.
     * @return Une liste des entités actives
     */
    List<T> findAllActive();
}