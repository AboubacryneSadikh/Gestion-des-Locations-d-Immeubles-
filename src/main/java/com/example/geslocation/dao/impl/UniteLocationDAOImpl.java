package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.UniteLocationDAO;
import com.example.geslocation.model.UniteLocation;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Implémentation DAO pour les opérations spécifiques aux unités de location.
 */
public class UniteLocationDAOImpl extends GenericDAOImpl<UniteLocation, Long> implements UniteLocationDAO {
    
    @Override
    public List<UniteLocation> findByImmeuble(Long immeubleId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<UniteLocation> query = em.createQuery(
                    "SELECT u FROM UniteLocation u WHERE u.immeuble.id = :immeubleId AND u.actif = true", 
                    UniteLocation.class);
            query.setParameter("immeubleId", immeubleId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<UniteLocation> findAllAvailable() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<UniteLocation> query = em.createQuery(
                    "SELECT u FROM UniteLocation u WHERE u.statut = :statut AND u.actif = true", 
                    UniteLocation.class);
            query.setParameter("statut", UniteLocation.Statut.DISPONIBLE);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<UniteLocation> findByNombreMinPieces(Integer nombreMinPieces) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<UniteLocation> query = em.createQuery(
                    "SELECT u FROM UniteLocation u WHERE u.nombrePieces >= :nombreMinPieces AND u.actif = true", 
                    UniteLocation.class);
            query.setParameter("nombreMinPieces", nombreMinPieces);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<UniteLocation> findByLoyerRange(BigDecimal loyerMin, BigDecimal loyerMax) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<UniteLocation> query = em.createQuery(
                    "SELECT u FROM UniteLocation u WHERE u.loyer >= :loyerMin AND u.loyer <= :loyerMax AND u.actif = true", 
                    UniteLocation.class);
            query.setParameter("loyerMin", loyerMin);
            query.setParameter("loyerMax", loyerMax);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<UniteLocation> searchByCriteria(Long immeubleId, Integer nombreMinPieces, 
                                              BigDecimal loyerMin, BigDecimal loyerMax, 
                                              Boolean disponible) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<UniteLocation> cq = cb.createQuery(UniteLocation.class);
            Root<UniteLocation> unite = cq.from(UniteLocation.class);
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Ajouter une condition pour actif = true
            predicates.add(cb.equal(unite.get("actif"), true));
            
            // Ajouter des conditions basées sur les critères fournis
            if (immeubleId != null) {
                predicates.add(cb.equal(unite.get("immeuble").get("id"), immeubleId));
            }
            
            if (nombreMinPieces != null) {
                predicates.add(cb.greaterThanOrEqualTo(unite.get("nombrePieces"), nombreMinPieces));
            }
            
            if (loyerMin != null) {
                predicates.add(cb.greaterThanOrEqualTo(unite.get("loyer"), loyerMin));
            }
            
            if (loyerMax != null) {
                predicates.add(cb.lessThanOrEqualTo(unite.get("loyer"), loyerMax));
            }
            
            if (disponible != null && disponible) {
                predicates.add(cb.equal(unite.get("statut"), UniteLocation.Statut.DISPONIBLE));
            }
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.select(unite);
            
            TypedQuery<UniteLocation> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateStatut(Long uniteId, UniteLocation.Statut statut) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            UniteLocation unite = em.find(UniteLocation.class, uniteId);
            if (unite != null) {
                unite.setStatut(statut);
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
}