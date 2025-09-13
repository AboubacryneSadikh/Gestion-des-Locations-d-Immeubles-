package com.example.geslocation.service.impl;

import com.example.geslocation.model.CandidatureLocation;
import com.example.geslocation.service.CandidatureLocationService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public class CandidatureLocationServiceImpl implements CandidatureLocationService {

    private final EntityManagerFactory emf;

    public CandidatureLocationServiceImpl() {
        // Utilisation de "GesLocationPU" pour correspondre au persistence.xml
        this.emf = Persistence.createEntityManagerFactory("GesLocationPU");
    }

    @Override
    public CandidatureLocation creer(CandidatureLocation candidature) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // Définir la date de création si elle n'est pas définie
            if (candidature.getDateCreation() == null) {
                candidature.setDateCreation(new Date());
            }

            // Définir le statut par défaut si non défini
            if (candidature.getStatut() == null) {
                candidature.setStatut(CandidatureLocation.Statut.EN_ATTENTE);
            }

            em.persist(candidature);
            em.getTransaction().commit();
            return candidature;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la création de la candidature", e);
        } finally {
            em.close();
        }
    }

    @Override
    public CandidatureLocation mettreAJour(CandidatureLocation candidature) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // Définir la date de modification
            candidature.setDateModification(new Date());

            CandidatureLocation updated = em.merge(candidature);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la candidature", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<CandidatureLocation> obtenirParId(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            CandidatureLocation candidature = em.find(CandidatureLocation.class, id);
            return Optional.ofNullable(candidature);
        } finally {
            em.close();
        }
    }

    @Override
    public List<CandidatureLocation> obtenirTous() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<CandidatureLocation> query = em.createQuery(
                    "SELECT c FROM CandidatureLocation c " +
                            "LEFT JOIN FETCH c.locataire l " +
                            "LEFT JOIN FETCH l.utilisateur " +
                            "LEFT JOIN FETCH c.unite u " +
                            "LEFT JOIN FETCH u.immeuble " +
                            "ORDER BY c.dateCreation DESC",
                    CandidatureLocation.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<CandidatureLocation> obtenirParProprietaire(Long proprietaireId, String statutFilter) {
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT c FROM CandidatureLocation c " +
                            "LEFT JOIN FETCH c.locataire l " +
                            "LEFT JOIN FETCH l.utilisateur " +
                            "LEFT JOIN FETCH c.unite u " +
                            "LEFT JOIN FETCH u.immeuble i " +
                            "WHERE i.proprietaire.id = :proprietaireId"
            );

            if (statutFilter != null && !statutFilter.isEmpty() && !statutFilter.equals("TOUS")) {
                jpql.append(" AND c.statut = :statut");
            }

            jpql.append(" ORDER BY c.dateCreation DESC");

            TypedQuery<CandidatureLocation> query = em.createQuery(jpql.toString(), CandidatureLocation.class);
            query.setParameter("proprietaireId", proprietaireId);

            if (statutFilter != null && !statutFilter.isEmpty() && !statutFilter.equals("TOUS")) {
                query.setParameter("statut", CandidatureLocation.Statut.valueOf(statutFilter));
            }

            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des candidatures du propriétaire", e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<CandidatureLocation> obtenirRecentesParProprietaire(Long proprietaireId, int limite) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<CandidatureLocation> query = em.createQuery(
                    "SELECT c FROM CandidatureLocation c " +
                            "LEFT JOIN FETCH c.locataire l " +
                            "LEFT JOIN FETCH l.utilisateur " +
                            "LEFT JOIN FETCH c.unite u " +
                            "LEFT JOIN FETCH u.immeuble i " +
                            "WHERE i.proprietaire.id = :proprietaireId " +
                            "ORDER BY c.dateCreation DESC",
                    CandidatureLocation.class
            );
            query.setParameter("proprietaireId", proprietaireId);
            query.setMaxResults(limite);
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la récupération des candidatures récentes", e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<CandidatureLocation> obtenirParLocataire(Long locataireId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<CandidatureLocation> query = em.createQuery(
                    "SELECT c FROM CandidatureLocation c " +
                            "LEFT JOIN FETCH c.unite u " +
                            "LEFT JOIN FETCH u.immeuble i " +
                            "LEFT JOIN FETCH i.proprietaire p " +
                            "WHERE c.locataire.id = :locataireId " +
                            "ORDER BY c.dateCreation DESC",
                    CandidatureLocation.class
            );
            query.setParameter("locataireId", locataireId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<CandidatureLocation> obtenirParUnite(Long uniteId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<CandidatureLocation> query = em.createQuery(
                    "SELECT c FROM CandidatureLocation c " +
                            "LEFT JOIN FETCH c.locataire l " +
                            "LEFT JOIN FETCH l.utilisateur " +
                            "WHERE c.unite.id = :uniteId " +
                            "ORDER BY c.dateCreation DESC",
                    CandidatureLocation.class
            );
            query.setParameter("uniteId", uniteId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean aCandidatureEnCours(Long locataireId, Long uniteId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM CandidatureLocation c " +
                            "WHERE c.locataire.id = :locataireId " +
                            "AND c.unite.id = :uniteId " +
                            "AND c.statut = :statut",
                    Long.class
            );
            query.setParameter("locataireId", locataireId);
            query.setParameter("uniteId", uniteId);
            query.setParameter("statut", CandidatureLocation.Statut.EN_ATTENTE);

            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public void refuserAutresCandidatures(Long uniteId, Long candidatureApprouveeId, String motifRefus) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // Récupérer toutes les candidatures en attente pour cette unité
            TypedQuery<CandidatureLocation> query = em.createQuery(
                    "SELECT c FROM CandidatureLocation c " +
                            "WHERE c.unite.id = :uniteId " +
                            "AND c.id != :candidatureApprouveeId " +
                            "AND c.statut = :statut",
                    CandidatureLocation.class
            );
            query.setParameter("uniteId", uniteId);
            query.setParameter("candidatureApprouveeId", candidatureApprouveeId);
            query.setParameter("statut", CandidatureLocation.Statut.EN_ATTENTE);

            List<CandidatureLocation> candidaturesARefuser = query.getResultList();

            // Refuser chaque candidature
            for (CandidatureLocation candidature : candidaturesARefuser) {
                candidature.setStatut(CandidatureLocation.Statut.REFUSEE);
                candidature.setCommentaireProprietaire(motifRefus);
                candidature.setDateReponse(new Date());
                em.merge(candidature);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors du refus des autres candidatures", e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean supprimer(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            CandidatureLocation candidature = em.find(CandidatureLocation.class, id);
            if (candidature != null) {
                em.remove(candidature);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la candidature", e);
        } finally {
            em.close();
        }
    }

    @Override
    public long compterParProprietaireEtStatut(Long proprietaireId, CandidatureLocation.Statut statut) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM CandidatureLocation c " +
                            "JOIN c.unite u " +
                            "JOIN u.immeuble i " +
                            "WHERE i.proprietaire.id = :proprietaireId " +
                            "AND c.statut = :statut",
                    Long.class
            );
            query.setParameter("proprietaireId", proprietaireId);
            query.setParameter("statut", statut);
            return query.getSingleResult();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des candidatures", e);
        } finally {
            em.close();
        }
    }

    /**
     * Ferme l'EntityManagerFactory lors de l'arrêt de l'application.
     * Cette méthode devrait être appelée dans un listener de contexte ou lors de l'arrêt de l'application.
     */
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}