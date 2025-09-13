package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.UtilisateurDAO;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation DAO pour les opérations spécifiques aux utilisateurs.
 */
public class UtilisateurDAOImpl extends GenericDAOImpl<Utilisateur, Long> implements UtilisateurDAO {
    
    @Override
    public Optional<Utilisateur> findByEmail(String email) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.email = :email", Utilisateur.class);
            query.setParameter("email", email);
            try {
                Utilisateur utilisateur = query.getSingleResult();
                return Optional.of(utilisateur);
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Utilisateur> authenticate(String email, String motDePasse) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.email = :email AND u.motDePasse = :motDePasse AND u.actif = true", 
                    Utilisateur.class);
            query.setParameter("email", email);
            query.setParameter("motDePasse", motDePasse); // Note: Dans une application réelle, le mot de passe devrait être haché
            try {
                Utilisateur utilisateur = query.getSingleResult();
                return Optional.of(utilisateur);
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateLastLogin(Long utilisateurId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Utilisateur utilisateur = em.find(Utilisateur.class, utilisateurId);
            if (utilisateur != null) {
                utilisateur.setDerniereConnexion(new Date());
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Utilisateur> findByRole(Utilisateur.Role role) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.role = :role AND u.actif = true", 
                    Utilisateur.class);
            query.setParameter("role", role);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}