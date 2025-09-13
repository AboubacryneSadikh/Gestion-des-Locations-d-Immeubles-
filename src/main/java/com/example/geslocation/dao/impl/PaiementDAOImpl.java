package com.example.geslocation.dao.impl;

import com.example.geslocation.dao.PaiementDAO;
import com.example.geslocation.model.Paiement;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Implémentation DAO pour les opérations spécifiques aux paiements.
 */
public class PaiementDAOImpl extends GenericDAOImpl<Paiement, Long> implements PaiementDAO {
    
    @Override
    public List<Paiement> findByContrat(Long contratId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Paiement> query = em.createQuery(
                    "SELECT p FROM Paiement p WHERE p.contrat.id = :contratId ORDER BY p.dateEcheance", 
                    Paiement.class);
            query.setParameter("contratId", contratId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Paiement> findAllPending() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Paiement> query = em.createQuery(
                    "SELECT p FROM Paiement p WHERE p.statut = :statut ORDER BY p.dateEcheance", 
                    Paiement.class);
            query.setParameter("statut", Paiement.Statut.EN_ATTENTE);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Paiement> findAllLate() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            Date aujourdhui = new Date();
            TypedQuery<Paiement> query = em.createQuery(
                    "SELECT p FROM Paiement p WHERE p.statut = :statut AND p.dateEcheance < :aujourdhui ORDER BY p.dateEcheance", 
                    Paiement.class);
            query.setParameter("statut", Paiement.Statut.EN_ATTENTE);
            query.setParameter("aujourdhui", aujourdhui);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Paiement> findByPaymentDateRange(Date dateDebut, Date dateFin) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Paiement> query = em.createQuery(
                    "SELECT p FROM Paiement p WHERE p.datePaiement >= :dateDebut AND p.datePaiement <= :dateFin " +
                    "AND p.statut = :statut ORDER BY p.datePaiement", 
                    Paiement.class);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            query.setParameter("statut", Paiement.Statut.PAYE);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Paiement> findByDueDateRange(Date dateDebut, Date dateFin) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Paiement> query = em.createQuery(
                    "SELECT p FROM Paiement p WHERE p.dateEcheance >= :dateDebut AND p.dateEcheance <= :dateFin " +
                    "ORDER BY p.dateEcheance", 
                    Paiement.class);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateStatut(Long paiementId, Paiement.Statut statut, Date datePaiement) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Paiement paiement = em.find(Paiement.class, paiementId);
            if (paiement != null) {
                paiement.setStatut(statut);
                if (statut == Paiement.Statut.PAYE && datePaiement != null) {
                    paiement.setDatePaiement(datePaiement);
                }
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
    public boolean markAsPaid(Long paiementId, Date datePaiement, String methodePaiement) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Paiement paiement = em.find(Paiement.class, paiementId);
            if (paiement != null) {
                paiement.setStatut(Paiement.Statut.PAYE);
                paiement.setDatePaiement(datePaiement);
                paiement.setMethodePaiement(methodePaiement);
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
    public boolean generateReceipt(Long paiementId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Paiement paiement = em.find(Paiement.class, paiementId);
            if (paiement != null && paiement.getStatut() == Paiement.Statut.PAYE) {
                paiement.setRecuGenere(true);
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
    public boolean sendReminder(Long paiementId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Paiement paiement = em.find(Paiement.class, paiementId);
            if (paiement != null && paiement.getStatut() == Paiement.Statut.EN_RETARD) {
                paiement.setRelanceEnvoyee(true);
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
    public BigDecimal calculateTotalPaymentsForContract(Long contratId) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<BigDecimal> query = em.createQuery(
                    "SELECT SUM(p.montant) FROM Paiement p WHERE p.contrat.id = :contratId AND p.statut = :statut", 
                    BigDecimal.class);
            query.setParameter("contratId", contratId);
            query.setParameter("statut", Paiement.Statut.PAYE);
            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Paiement> searchByCriteria(Long contratId, Paiement.Statut statut, 
                                         Date dateEcheanceMin, Date dateEcheanceMax, 
                                         BigDecimal montantMin, BigDecimal montantMax) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Paiement> cq = cb.createQuery(Paiement.class);
            Root<Paiement> paiement = cq.from(Paiement.class);
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Ajouter des conditions basées sur les critères fournis
            if (contratId != null) {
                predicates.add(cb.equal(paiement.get("contrat").get("id"), contratId));
            }
            
            if (statut != null) {
                predicates.add(cb.equal(paiement.get("statut"), statut));
            }
            
            if (dateEcheanceMin != null) {
                predicates.add(cb.greaterThanOrEqualTo(paiement.get("dateEcheance"), dateEcheanceMin));
            }
            
            if (dateEcheanceMax != null) {
                predicates.add(cb.lessThanOrEqualTo(paiement.get("dateEcheance"), dateEcheanceMax));
            }
            
            if (montantMin != null) {
                predicates.add(cb.greaterThanOrEqualTo(paiement.get("montant"), montantMin));
            }
            
            if (montantMax != null) {
                predicates.add(cb.lessThanOrEqualTo(paiement.get("montant"), montantMax));
            }
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.orderBy(cb.asc(paiement.get("dateEcheance")));
            cq.select(paiement);
            
            TypedQuery<Paiement> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}