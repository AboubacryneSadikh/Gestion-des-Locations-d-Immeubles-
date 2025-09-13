package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.ImmeubleDAO;
import com.example.geslocation.model.Immeuble;
import com.example.geslocation.model.UniteLocation;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.ArrayList;
import java.util.List;

/**
 * Implémentation DAO pour les opérations spécifiques aux immeubles.
 */
public class ImmeubleDAOImpl extends GenericDAOImpl<Immeuble, Long> implements ImmeubleDAO {
    
    @Override
    public List<Immeuble> findByProprietaire(Long proprietaireId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Immeuble> query = em.createQuery(
                    "SELECT i FROM Immeuble i WHERE i.proprietaire.id = :proprietaireId AND i.actif = true", 
                    Immeuble.class);
            query.setParameter("proprietaireId", proprietaireId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Immeuble> findByVille(String ville) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Immeuble> query = em.createQuery(
                    "SELECT i FROM Immeuble i WHERE LOWER(i.ville) = LOWER(:ville) AND i.actif = true", 
                    Immeuble.class);
            query.setParameter("ville", ville);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Immeuble> findByNombreMinUnites(Integer nombreMinUnites) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Immeuble> query = em.createQuery(
                    "SELECT i FROM Immeuble i WHERE i.nombreUnites >= :nombreMinUnites AND i.actif = true", 
                    Immeuble.class);
            query.setParameter("nombreMinUnites", nombreMinUnites);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Long countUnitesForProprietaire(Long proprietaireId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT SUM(i.nombreUnites) FROM Immeuble i WHERE i.proprietaire.id = :proprietaireId AND i.actif = true", 
                    Long.class);
            query.setParameter("proprietaireId", proprietaireId);
            Long result = query.getSingleResult();
            return result != null ? result : 0L;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Immeuble> searchByCriteria(String ville, Integer nombreMinPieces, Double loyerMin, Double loyerMax) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Immeuble> cq = cb.createQuery(Immeuble.class);
            Root<Immeuble> immeuble = cq.from(Immeuble.class);
            Join<Immeuble, UniteLocation> unite = immeuble.join("unites");
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Ajouter une condition pour actif = true
            predicates.add(cb.equal(immeuble.get("actif"), true));
            
            // Ajouter des conditions basées sur les critères fournis
            if (ville != null && !ville.isEmpty()) {
                predicates.add(cb.equal(cb.lower(immeuble.get("ville")), ville.toLowerCase()));
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
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.select(immeuble).distinct(true);
            
            TypedQuery<Immeuble> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}