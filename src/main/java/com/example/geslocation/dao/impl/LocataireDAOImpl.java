package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.LocataireDAO;
import com.example.geslocation.model.Locataire;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation DAO pour les opérations spécifiques aux locataires.
 */
public class LocataireDAOImpl extends GenericDAOImpl<Locataire, Long> implements LocataireDAO {
    
    @Override
    public Optional<Locataire> findByUtilisateur(Long utilisateurId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Locataire> query = em.createQuery(
                    "SELECT l FROM Locataire l WHERE l.utilisateur.id = :utilisateurId AND l.actif = true", 
                    Locataire.class);
            query.setParameter("utilisateurId", utilisateurId);
            try {
                Locataire locataire = query.getSingleResult();
                return Optional.of(locataire);
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Locataire> findByEmail(String email) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Locataire> query = em.createQuery(
                    "SELECT l FROM Locataire l JOIN l.utilisateur u WHERE u.email = :email AND l.actif = true", 
                    Locataire.class);
            query.setParameter("email", email);
            try {
                Locataire locataire = query.getSingleResult();
                return Optional.of(locataire);
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Locataire> findByRevenuMin(Double revenuMin) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Locataire> query = em.createQuery(
                    "SELECT l FROM Locataire l WHERE l.revenuMensuel >= :revenuMin AND l.actif = true", 
                    Locataire.class);
            query.setParameter("revenuMin", revenuMin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Locataire createWithUtilisateur(Locataire locataire, Utilisateur utilisateur) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            
            // Vérifier si l'utilisateur existe déjà
            if (utilisateur.getId() == null) {
                em.persist(utilisateur);
            } else {
                utilisateur = em.merge(utilisateur);
            }
            
            // Associer l'utilisateur au locataire
            locataire.setUtilisateur(utilisateur);
            
            // Persister le locataire
            em.persist(locataire);
            
            em.getTransaction().commit();
            return locataire;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Locataire> searchByCriteria(String nom, String prenom, Double revenuMin) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Locataire> cq = cb.createQuery(Locataire.class);
            Root<Locataire> locataire = cq.from(Locataire.class);
            Join<Locataire, Utilisateur> utilisateur = locataire.join("utilisateur");
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Ajouter une condition pour actif = true
            predicates.add(cb.equal(locataire.get("actif"), true));
            
            // Ajouter des conditions basées sur les critères fournis
            if (nom != null && !nom.isEmpty()) {
                predicates.add(cb.like(cb.lower(utilisateur.get("nom")), "%" + nom.toLowerCase() + "%"));
            }
            
            if (prenom != null && !prenom.isEmpty()) {
                predicates.add(cb.like(cb.lower(utilisateur.get("prenom")), "%" + prenom.toLowerCase() + "%"));
            }
            
            if (revenuMin != null) {
                predicates.add(cb.greaterThanOrEqualTo(locataire.get("revenuMensuel"), revenuMin));
            }
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.select(locataire);
            
            TypedQuery<Locataire> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}