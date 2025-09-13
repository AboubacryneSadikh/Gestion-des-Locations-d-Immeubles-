package com.example.geslocation.service.impl;

import com.example.geslocation.dao.ContratLocationDAO;
import com.example.geslocation.dao.PaiementDAO;
import com.example.geslocation.dao.impl.ContratLocationDAOImpl;
import com.example.geslocation.dao.impl.PaiementDAOImpl;
import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Paiement;
import com.example.geslocation.service.PaiementService;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Implémentation du service pour les opérations liées aux paiements.
 */
public class PaiementServiceImpl implements PaiementService {
    
    private final PaiementDAO paiementDAO;
    private final ContratLocationDAO contratLocationDAO;
    
    /**
     * Constructeur par défaut qui initialise les DAOs.
     */
    public PaiementServiceImpl() {
        this.paiementDAO = new PaiementDAOImpl();
        this.contratLocationDAO = new ContratLocationDAOImpl();
    }
    
    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param paiementDAO Le DAO des paiements
     * @param contratLocationDAO Le DAO des contrats de location
     */
    public PaiementServiceImpl(PaiementDAO paiementDAO, ContratLocationDAO contratLocationDAO) {
        this.paiementDAO = paiementDAO;
        this.contratLocationDAO = contratLocationDAO;
    }

    @Override
    public Paiement creer(Paiement paiement) throws Exception {
        // Générer un numéro de référence unique si non défini
        if (paiement.getNumeroReference() == null || paiement.getNumeroReference().isEmpty()) {
            paiement.setNumeroReference("PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }

        // Définir le statut par défaut si non défini
        if (paiement.getStatut() == null) {
            paiement.setStatut(Paiement.Statut.EN_ATTENTE);
        }

        // Définir la date de création
        if (paiement.getDateCreation() == null) {
            paiement.setDateCreation(new Date());
        }

        // Persister le paiement
        return paiementDAO.create(paiement);
    }
    
    @Override
    public Optional<Paiement> obtenirParId(Long id) {
        return paiementDAO.findById(id);
    }
    
    @Override
    public Paiement mettreAJour(Paiement paiement) throws Exception {
        // Vérifier si le paiement existe
        Optional<Paiement> optPaiement = paiementDAO.findById(paiement.getId());
        if (!optPaiement.isPresent()) {
            throw new Exception("Paiement non trouvé.");
        }
        
        // Conserver le contrat et le numéro de référence
        Paiement existingPaiement = optPaiement.get();
        paiement.setContrat(existingPaiement.getContrat());
        paiement.setNumeroReference(existingPaiement.getNumeroReference());
        
        // Mettre à jour le paiement
        return paiementDAO.update(paiement);
    }
    
    @Override
    public boolean supprimer(Long id) {
        return paiementDAO.delete(id);
    }
    
    @Override
    public List<Paiement> obtenirTous() {
        return paiementDAO.findAll();
    }
    
    @Override
    public List<Paiement> obtenirParContrat(Long contratId) {
        return paiementDAO.findByContrat(contratId);
    }
    
    @Override
    public List<Paiement> obtenirEnAttente() {
        return paiementDAO.findAllPending();
    }
    
    @Override
    public List<Paiement> obtenirEnRetard() {
        return paiementDAO.findAllLate();
    }
    
    @Override
    public List<Paiement> obtenirParDatePaiement(Date dateDebut, Date dateFin) {
        return paiementDAO.findByPaymentDateRange(dateDebut, dateFin);
    }
    
    @Override
    public List<Paiement> obtenirParDateEcheance(Date dateDebut, Date dateFin) {
        return paiementDAO.findByDueDateRange(dateDebut, dateFin);
    }
    
    @Override
    public boolean marquerCommePaye(Long paiementId, Date datePaiement, String methodePaiement) {
        // Vérifier si le paiement existe
        Optional<Paiement> optPaiement = paiementDAO.findById(paiementId);
        if (!optPaiement.isPresent()) {
            return false;
        }
        
        Paiement paiement = optPaiement.get();
        
        // Vérifier si le paiement n'est pas déjà payé
        if (paiement.getStatut() == Paiement.Statut.PAYE) {
            return false;
        }
        
        // Marquer le paiement comme payé
        return paiementDAO.markAsPaid(paiementId, datePaiement, methodePaiement);
    }
    
    @Override
    public boolean marquerCommeEnRetard(Long paiementId) {
        // Vérifier si le paiement existe
        Optional<Paiement> optPaiement = paiementDAO.findById(paiementId);
        if (!optPaiement.isPresent()) {
            return false;
        }
        
        Paiement paiement = optPaiement.get();
        
        // Vérifier si le paiement est en attente et la date d'échéance est passée
        if (paiement.getStatut() != Paiement.Statut.EN_ATTENTE || 
            paiement.getDateEcheance().after(new Date())) {
            return false;
        }
        
        // Marquer le paiement comme en retard
        return paiementDAO.updateStatut(paiementId, Paiement.Statut.EN_RETARD, null);
    }
    
    @Override
    public boolean genererRecu(Long paiementId) {
        return paiementDAO.generateReceipt(paiementId);
    }
    
    @Override
    public boolean envoyerRelance(Long paiementId) {
        return paiementDAO.sendReminder(paiementId);
    }
    
    @Override
    public BigDecimal calculerTotalPaiementsContrat(Long contratId) {
        return paiementDAO.calculateTotalPaymentsForContract(contratId);
    }
    
    @Override
    public List<Paiement> rechercher(Long contratId, Paiement.Statut statut, 
                                   Date dateEcheanceMin, Date dateEcheanceMax, 
                                   BigDecimal montantMin, BigDecimal montantMax) {
        return paiementDAO.searchByCriteria(contratId, statut, dateEcheanceMin, dateEcheanceMax, montantMin, montantMax);
    }
    
    /**
     * Vérifie et met à jour le statut des paiements en retard.
     * Cette méthode pourrait être appelée par un job planifié.
     * @return Le nombre de paiements mis à jour
     */
    @Override
    public int verifierEtMettreAJourPaiementsEnRetard() {
        List<Paiement> paiementsEnAttente = paiementDAO.findAllPending();
        Date aujourdhui = new Date();
        int count = 0;
        
        for (Paiement paiement : paiementsEnAttente) {
            if (paiement.getDateEcheance().before(aujourdhui)) {
                if (paiementDAO.updateStatut(paiement.getId(), Paiement.Statut.EN_RETARD, null)) {
                    count++;
                }
            }
        }
        
        return count;
    }

    /**
     * Génère les paiements mensuels pour un contrat donné
     * @param contrat Le contrat pour lequel générer les paiements
     */
    @Override
    public void genererPaiementsMensuels(ContratLocation contrat) {
        if (contrat == null || contrat.getId() == null) {
            System.err.println("ERREUR: Contrat invalide pour la génération de paiements");
            return;
        }

        Calendar cal = Calendar.getInstance();
        cal.setTime(contrat.getDateDebut());

        Date dateFinContrat = contrat.getDateFin();
        Date aujourdhui = new Date();

        System.out.println("DEBUG: Génération paiements pour contrat " + contrat.getId());
        System.out.println("DEBUG: Du " + contrat.getDateDebut() + " au " + dateFinContrat);
        System.out.println("DEBUG: Jour de paiement: " + contrat.getJourPaiement());

        // CORRECTION 1: Récupérer TOUS les paiements existants UNE SEULE FOIS
        List<Paiement> paiementsExistants = paiementDAO.findByContrat(contrat.getId());
        System.out.println("DEBUG: " + paiementsExistants.size() + " paiements existants trouvés");

        // CORRECTION 2: Créer un Set des périodes (mois/année) déjà couvertes
        Set<String> periodesExistantes = paiementsExistants.stream()
                .map(p -> {
                    Calendar existingCal = Calendar.getInstance();
                    existingCal.setTime(p.getDateEcheance());
                    return existingCal.get(Calendar.YEAR) + "-" + String.format("%02d", existingCal.get(Calendar.MONTH) + 1);
                })
                .collect(Collectors.toSet());

        System.out.println("DEBUG: Périodes existantes: " + periodesExistantes);

        int paiementsCrees = 0;

        while (cal.getTime().before(dateFinContrat) || cal.getTime().equals(dateFinContrat)) {
            // Date d'échéance = jour de paiement du mois
            Calendar echeance = Calendar.getInstance();
            echeance.setTime(cal.getTime());
            int jourPaiement = Math.max(1, Math.min(contrat.getJourPaiement(),
                    echeance.getActualMaximum(Calendar.DAY_OF_MONTH)));
            echeance.set(Calendar.DAY_OF_MONTH, jourPaiement);

            // CORRECTION 3: Vérification améliorée des doublons
            String periodeActuelle = echeance.get(Calendar.YEAR) + "-" +
                    String.format("%02d", echeance.get(Calendar.MONTH) + 1);

            if (!periodesExistantes.contains(periodeActuelle)) {
                System.out.println("DEBUG: Création paiement pour période: " + periodeActuelle);

                Paiement paiement = new Paiement();
                paiement.setContrat(contrat);

                // CORRECTION 4: Calculer le montant correctement
                BigDecimal montantTotal = contrat.getLoyer();
                if (contrat.getChargesMensuelles() != null && contrat.getChargesMensuelles().compareTo(BigDecimal.ZERO) > 0) {
                    montantTotal = montantTotal.add(contrat.getChargesMensuelles());
                }
                paiement.setMontant(montantTotal);

                paiement.setDateEcheance(echeance.getTime());
                paiement.setTypePaiement("LOYER");

                // Déterminer le statut selon la date
                if (echeance.getTime().before(aujourdhui)) {
                    paiement.setStatut(Paiement.Statut.EN_RETARD);
                } else {
                    paiement.setStatut(Paiement.Statut.EN_ATTENTE);
                }

                paiement.setDateCreation(new Date());
                paiement.setNumeroReference("PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

                try {
                    Paiement paiementCree = paiementDAO.create(paiement);
                    // CORRECTION 5: Ajouter immédiatement à la liste des périodes existantes
                    periodesExistantes.add(periodeActuelle);
                    paiementsCrees++;

                    System.out.println("DEBUG: Paiement créé - ID: " + paiementCree.getId() +
                            ", Période: " + periodeActuelle +
                            ", Échéance: " + paiement.getDateEcheance() +
                            ", Statut: " + paiement.getStatut());

                } catch (Exception e) {
                    System.err.println("ERREUR lors de la création du paiement pour " + periodeActuelle + ": " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("DEBUG: Paiement déjà existant pour période: " + periodeActuelle);
            }

            // Passer au mois suivant
            cal.add(Calendar.MONTH, 1);
        }

        System.out.println("DEBUG: Génération terminée - " + paiementsCrees + " nouveaux paiements créés");
    }

    @Override
    public boolean paiementExistePourPeriode(Long contratId, Date dateEcheance) {
        List<Paiement> paiements = paiementDAO.findByContrat(contratId);

        Calendar targetCal = Calendar.getInstance();
        targetCal.setTime(dateEcheance);
        int targetMonth = targetCal.get(Calendar.MONTH);
        int targetYear = targetCal.get(Calendar.YEAR);

        return paiements.stream().anyMatch(p -> {
            Calendar paiementCal = Calendar.getInstance();
            paiementCal.setTime(p.getDateEcheance());
            return paiementCal.get(Calendar.MONTH) == targetMonth &&
                    paiementCal.get(Calendar.YEAR) == targetYear;
        });
    }

    /**
     * Supprime les paiements en double pour un contrat donné
     * @param contratId L'ID du contrat
     * @return Le nombre de doublons supprimés
     */
    @Override
    public int supprimerPaiementsEnDouble(Long contratId) {
        List<Paiement> paiements = paiementDAO.findByContrat(contratId);

        // Grouper par période (mois/année)
        Map<String, List<Paiement>> paiementsParPeriode = paiements.stream()
                .collect(Collectors.groupingBy(p -> {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(p.getDateEcheance());
                    return cal.get(Calendar.YEAR) + "-" + String.format("%02d", cal.get(Calendar.MONTH) + 1);
                }));

        int supprimesCount = 0;

        // Pour chaque période, garder seulement le premier paiement non payé
        for (Map.Entry<String, List<Paiement>> entry : paiementsParPeriode.entrySet()) {
            List<Paiement> paiementsPeriode = entry.getValue();

            if (paiementsPeriode.size() > 1) {
                System.out.println("DEBUG: Trouvé " + paiementsPeriode.size() + " paiements pour la période " + entry.getKey());

                // Trier pour garder le plus ancien ou le payé en priorité
                paiementsPeriode.sort((p1, p2) -> {
                    // Les paiements payés ont priorité
                    if (p1.getStatut() == Paiement.Statut.PAYE && p2.getStatut() != Paiement.Statut.PAYE) {
                        return -1;
                    }
                    if (p2.getStatut() == Paiement.Statut.PAYE && p1.getStatut() != Paiement.Statut.PAYE) {
                        return 1;
                    }
                    // Sinon, le plus ancien
                    return p1.getDateCreation().compareTo(p2.getDateCreation());
                });

                // Garder le premier, supprimer les autres
                for (int i = 1; i < paiementsPeriode.size(); i++) {
                    Paiement aSupprimer = paiementsPeriode.get(i);
                    // Ne supprimer que les paiements non payés
                    if (aSupprimer.getStatut() != Paiement.Statut.PAYE) {
                        if (paiementDAO.delete(aSupprimer.getId())) {
                            supprimesCount++;
                            System.out.println("DEBUG: Paiement en double supprimé - ID: " + aSupprimer.getId());
                        }
                    }
                }
            }
        }

        return supprimesCount;
    }


    @Override
    public void mettreAJourStatutsPaiements() {
        Date aujourdhui = new Date();

        // Récupérer tous les paiements non payés
        List<Paiement> paiementsNonPayes = paiementDAO.findAll().stream()
                .filter(p -> p.getStatut() != Paiement.Statut.PAYE)
                .collect(Collectors.toList());

        for (Paiement paiement : paiementsNonPayes) {
            Paiement.Statut ancienStatut = paiement.getStatut();
            Paiement.Statut nouveauStatut;

            if (paiement.getDateEcheance().before(aujourdhui)) {
                // Si l'échéance est passée, c'est en retard
                nouveauStatut = Paiement.Statut.EN_RETARD;
            } else {
                // Si l'échéance est future ou aujourd'hui, c'est en attente
                nouveauStatut = Paiement.Statut.EN_ATTENTE;
            }

            // Sauvegarder seulement si le statut a changé
            if (ancienStatut != nouveauStatut) {
                paiementDAO.updateStatut(paiement.getId(), nouveauStatut, null);
                System.out.println("DEBUG: Statut mis à jour pour paiement ID: " + paiement.getId() +
                        " - Ancien: " + ancienStatut + ", Nouveau: " + nouveauStatut);
            }
        }
    }

    /**
     * Créer un paiement immédiat pour permettre le paiement anticipé
     */
    @Override
    public Paiement creerPaiementImmediat(ContratLocation contrat, String typePaiement) throws Exception {
        // Vérifier d'abord s'il n'y a pas déjà un paiement pour le mois courant/suivant
        Calendar cal = Calendar.getInstance();

        // Si on est avant le jour de paiement du mois, créer pour le mois courant
        // Sinon, créer pour le mois suivant
        if (cal.get(Calendar.DAY_OF_MONTH) >= contrat.getJourPaiement()) {
            cal.add(Calendar.MONTH, 1);
        }

        int jourPaiement = Math.max(1, Math.min(contrat.getJourPaiement(),
                cal.getActualMaximum(Calendar.DAY_OF_MONTH)));
        cal.set(Calendar.DAY_OF_MONTH, jourPaiement);

        // CORRECTION: Vérifier si un paiement existe déjà pour cette période
        if (paiementExistePourPeriode(contrat.getId(), cal.getTime())) {
            throw new Exception("Un paiement existe déjà pour cette période");
        }

        Paiement paiement = new Paiement();
        paiement.setContrat(contrat);
        paiement.setMontant(contrat.getLoyer());
        paiement.setDateEcheance(cal.getTime());
        paiement.setTypePaiement(typePaiement);
        paiement.setStatut(Paiement.Statut.EN_ATTENTE);
        paiement.setDateCreation(new Date());

        return creer(paiement);
    }

}