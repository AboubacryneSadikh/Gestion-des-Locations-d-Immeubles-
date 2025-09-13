package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.ContratLocationDAO;
import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Implémentation DAO pour les opérations spécifiques aux contrats de location.
 */
public class ContratLocationDAOImpl extends GenericDAOImpl<ContratLocation, Long> implements ContratLocationDAO {
    
    @Override
    public List<ContratLocation> findByLocataire(Long locataireId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<ContratLocation> query = em.createQuery(
                    "SELECT c FROM ContratLocation c WHERE c.locataire.id = :locataireId AND c.actif = true", 
                    ContratLocation.class);
            query.setParameter("locataireId", locataireId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<ContratLocation> findByUnite(Long uniteId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<ContratLocation> query = em.createQuery(
                    "SELECT c FROM ContratLocation c WHERE c.unite.id = :uniteId AND c.actif = true", 
                    ContratLocation.class);
            query.setParameter("uniteId", uniteId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<ContratLocation> findAllActive() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<ContratLocation> query = em.createQuery(
                    "SELECT c FROM ContratLocation c WHERE c.statut = :statut AND c.actif = true", 
                    ContratLocation.class);
            query.setParameter("statut", ContratLocation.Statut.EN_COURS);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<ContratLocation> findExpiringInDays(int jours) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            // Calculer la date limite (aujourd'hui + jours)
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, jours);
            Date dateLimite = cal.getTime();
            
            // Aujourd'hui
            Date aujourdhui = new Date();
            
            TypedQuery<ContratLocation> query = em.createQuery(
                    "SELECT c FROM ContratLocation c WHERE c.dateFin >= :aujourdhui AND c.dateFin <= :dateLimite " +
                    "AND c.statut = :statut AND c.actif = true", 
                    ContratLocation.class);
            query.setParameter("aujourdhui", aujourdhui);
            query.setParameter("dateLimite", dateLimite);
            query.setParameter("statut", ContratLocation.Statut.EN_COURS);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<ContratLocation> findByCreationDateRange(Date dateDebut, Date dateFin) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<ContratLocation> query = em.createQuery(
                    "SELECT c FROM ContratLocation c WHERE c.dateCreation >= :dateDebut AND c.dateCreation <= :dateFin " +
                    "AND c.actif = true", 
                    ContratLocation.class);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateStatut(Long contratId, ContratLocation.Statut statut) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            ContratLocation contrat = em.find(ContratLocation.class, contratId);
            if (contrat != null) {
                contrat.setStatut(statut);
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
    public List<ContratLocation> searchByCriteria(Long locataireId, Long uniteId, 
                                                ContratLocation.Statut statut, 
                                                Date dateDebutMin, Date dateFinMax) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<ContratLocation> cq = cb.createQuery(ContratLocation.class);
            Root<ContratLocation> contrat = cq.from(ContratLocation.class);
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Ajouter une condition pour actif = true
            predicates.add(cb.equal(contrat.get("actif"), true));
            
            // Ajouter des conditions basées sur les critères fournis
            if (locataireId != null) {
                predicates.add(cb.equal(contrat.get("locataire").get("id"), locataireId));
            }
            
            if (uniteId != null) {
                predicates.add(cb.equal(contrat.get("unite").get("id"), uniteId));
            }
            
            if (statut != null) {
                predicates.add(cb.equal(contrat.get("statut"), statut));
            }
            
            if (dateDebutMin != null) {
                predicates.add(cb.greaterThanOrEqualTo(contrat.get("dateDebut"), dateDebutMin));
            }
            
            if (dateFinMax != null) {
                predicates.add(cb.lessThanOrEqualTo(contrat.get("dateFin"), dateFinMax));
            }
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.select(contrat);
            
            TypedQuery<ContratLocation> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}