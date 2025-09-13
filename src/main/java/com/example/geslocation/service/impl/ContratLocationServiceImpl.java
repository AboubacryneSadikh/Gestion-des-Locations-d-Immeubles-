package com.example.geslocation.service.impl;

import com.example.geslocation.dao.ContratLocationDAO;
import com.example.geslocation.dao.LocataireDAO;
import com.example.geslocation.dao.PaiementDAO;
import com.example.geslocation.dao.UniteLocationDAO;
import com.example.geslocation.dao.impl.ContratLocationDAOImpl;
import com.example.geslocation.dao.impl.LocataireDAOImpl;
import com.example.geslocation.dao.impl.PaiementDAOImpl;
import com.example.geslocation.dao.impl.UniteLocationDAOImpl;
import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Locataire;
import com.example.geslocation.model.Paiement;
import com.example.geslocation.model.UniteLocation;
import com.example.geslocation.service.ContratLocationService;
import com.example.geslocation.service.EmailService;
import com.example.geslocation.service.PaiementService;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Implémentation du service pour les opérations liées aux contrats de location.
 */
public class ContratLocationServiceImpl implements ContratLocationService {

    private final ContratLocationDAO contratLocationDAO;
    private final LocataireDAO locataireDAO;
    private final UniteLocationDAO uniteLocationDAO;
    private final PaiementDAO paiementDAO;
    private final EmailService emailService;
    private final PaiementService paiementService;

    /**
     * Constructeur par défaut qui initialise les DAOs.
     */
    public ContratLocationServiceImpl() {
        this.contratLocationDAO = new ContratLocationDAOImpl();
        this.locataireDAO = new LocataireDAOImpl();
        this.uniteLocationDAO = new UniteLocationDAOImpl();
        this.paiementDAO = new PaiementDAOImpl();
        this.emailService = new EmailServiceImpl();
        this.paiementService = new PaiementServiceImpl();
    }

    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param contratLocationDAO Le DAO des contrats de location
     * @param locataireDAO Le DAO des locataires
     * @param uniteLocationDAO Le DAO des unités de location
     * @param paiementDAO Le DAO des paiements
     * @param emailService Le service d'envoi d'emails
     * @param paiementService Le service des paiements
     */
    public ContratLocationServiceImpl(ContratLocationDAO contratLocationDAO, LocataireDAO locataireDAO,
                                      UniteLocationDAO uniteLocationDAO, PaiementDAO paiementDAO,
                                      EmailService emailService, PaiementService paiementService) {
        this.contratLocationDAO = contratLocationDAO;
        this.locataireDAO = locataireDAO;
        this.uniteLocationDAO = uniteLocationDAO;
        this.paiementDAO = paiementDAO;
        this.emailService = emailService;
        this.paiementService = paiementService;
    }

    @Override
    public ContratLocation creer(ContratLocation contrat) throws Exception {
        // Validation des données obligatoires
        if (contrat.getLocataire() == null) {
            throw new Exception("Le locataire est obligatoire pour créer un contrat.");
        }

        if (contrat.getUnite() == null) {
            throw new Exception("L'unité de location est obligatoire pour créer un contrat.");
        }

        // Vérifier si l'unité est disponible ou réservée
        UniteLocation unite = contrat.getUnite();
        if (unite.getStatut() != UniteLocation.Statut.DISPONIBLE &&
                unite.getStatut() != UniteLocation.Statut.RESERVE) {
            throw new Exception("L'unité de location n'est pas disponible pour la location.");
        }

        // Définir la date de création
        contrat.setDateCreation(new Date());

        // Générer un numéro de contrat unique si non défini
        if (contrat.getNumeroContrat() == null || contrat.getNumeroContrat().isEmpty()) {
            contrat.setNumeroContrat("CONT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }

        // Si le loyer n'est pas défini, utiliser celui de l'unité
        if (contrat.getLoyer() == null) {
            contrat.setLoyer(unite.getLoyer());
        }

        // Si les charges mensuelles ne sont pas définies, utiliser celles de l'unité
        if (contrat.getChargesMensuelles() == null) {
            contrat.setChargesMensuelles(unite.getChargesMensuelles());
        }

        // Si le dépôt de garantie n'est pas défini, utiliser celui de l'unité
        if (contrat.getDepotGarantie() == null) {
            contrat.setDepotGarantie(unite.getDepotGarantie());
        }

        // Définir le statut initial si non défini
        if (contrat.getStatut() == null) {
            contrat.setStatut(ContratLocation.Statut.EN_ATTENTE);
        }

        // Définir le jour de paiement par défaut si non défini
        if (contrat.getJourPaiement() == 0) {
            contrat.setJourPaiement(5);
        }

        // Persister le contrat
        ContratLocation savedContrat = contratLocationDAO.create(contrat);

        // Mettre à jour le statut de l'unité selon le statut du contrat
        if (contrat.getStatut() == ContratLocation.Statut.EN_COURS) {
            uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.LOUE);
        } else if (contrat.getStatut() == ContratLocation.Statut.EN_ATTENTE) {
            uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.RESERVE);
        }

        // NOUVEAU: Générer automatiquement les paiements mensuels
        try {
            System.out.println("DEBUG: Génération automatique des paiements pour le contrat " + savedContrat.getId());
            paiementService.genererPaiementsMensuels(savedContrat);
            System.out.println("DEBUG: Paiements générés avec succès pour le contrat " + savedContrat.getId());
        } catch (Exception e) {
            System.err.println("ERREUR lors de la génération des paiements pour le contrat " +
                    savedContrat.getId() + ": " + e.getMessage());
            e.printStackTrace();
            // Ne pas faire échouer la création du contrat pour autant
        }

        return savedContrat;
    }

    @Override
    public ContratLocation creer(ContratLocation contrat, Long locataireId, Long uniteId) throws Exception {
        // Vérifier si le locataire existe
        Optional<Locataire> optLocataire = locataireDAO.findById(locataireId);
        if (!optLocataire.isPresent()) {
            throw new Exception("Locataire non trouvé.");
        }

        // Vérifier si l'unité existe
        Optional<UniteLocation> optUnite = uniteLocationDAO.findById(uniteId);
        if (!optUnite.isPresent()) {
            throw new Exception("Unité de location non trouvée.");
        }

        // Définir le locataire et l'unité
        contrat.setLocataire(optLocataire.get());
        contrat.setUnite(optUnite.get());

        // Utiliser la méthode creer(ContratLocation) pour le reste de la logique
        return creer(contrat);
    }

    @Override
    public Optional<ContratLocation> obtenirParId(Long id) {
        return contratLocationDAO.findById(id);
    }

    @Override
    public ContratLocation mettreAJour(ContratLocation contrat) throws Exception {
        // Vérifier si le contrat existe
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(contrat.getId());
        if (!optContrat.isPresent()) {
            throw new Exception("Contrat de location non trouvé.");
        }

        // Conserver certaines données sensibles
        ContratLocation existingContrat = optContrat.get();
        contrat.setDateCreation(existingContrat.getDateCreation());

        // Si le numéro de contrat n'est pas défini, conserver l'existant
        if (contrat.getNumeroContrat() == null || contrat.getNumeroContrat().isEmpty()) {
            contrat.setNumeroContrat(existingContrat.getNumeroContrat());
        }

        // Mettre à jour la date de modification
        contrat.setDateModification(new Date());

        // Vérifier si le statut a changé pour mettre à jour l'unité
        ContratLocation.Statut ancienStatut = existingContrat.getStatut();
        ContratLocation.Statut nouveauStatut = contrat.getStatut();

        // Mettre à jour le contrat
        ContratLocation updatedContrat = contratLocationDAO.update(contrat);

        // Gérer les changements de statut de l'unité
        if (ancienStatut != nouveauStatut && contrat.getUnite() != null) {
            UniteLocation unite = contrat.getUnite();

            if (nouveauStatut == ContratLocation.Statut.EN_COURS) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.LOUE);

                // NOUVEAU: Générer les paiements si le contrat passe en cours
                try {
                    System.out.println("DEBUG: Contrat activé - Génération des paiements pour le contrat " + contrat.getId());
                    paiementService.genererPaiementsMensuels(updatedContrat);
                    System.out.println("DEBUG: Paiements générés suite à l'activation du contrat " + contrat.getId());
                } catch (Exception e) {
                    System.err.println("ERREUR lors de la génération des paiements suite à l'activation : " + e.getMessage());
                    // Ne pas faire échouer la mise à jour du contrat
                }
            } else if (nouveauStatut == ContratLocation.Statut.RESILIE ||
                    nouveauStatut == ContratLocation.Statut.TERMINE) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.DISPONIBLE);
            } else if (nouveauStatut == ContratLocation.Statut.EN_ATTENTE) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.RESERVE);
            }
        }

        return updatedContrat;
    }

    @Override
    public boolean supprimer(Long id) {
        // Récupérer le contrat
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(id);
        if (!optContrat.isPresent()) {
            return false;
        }

        ContratLocation contrat = optContrat.get();
        UniteLocation unite = contrat.getUnite();

        // Supprimer le contrat
        boolean success = contratLocationDAO.delete(id);

        // Si la suppression a réussi et que le contrat était actif, libérer l'unité
        if (success && unite != null &&
                (contrat.getStatut() == ContratLocation.Statut.EN_COURS ||
                        contrat.getStatut() == ContratLocation.Statut.EN_ATTENTE)) {
            uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.DISPONIBLE);
        }

        return success;
    }

    @Override
    public List<ContratLocation> obtenirTous() {
        return contratLocationDAO.findAll();
    }

    @Override
    public List<ContratLocation> obtenirParLocataire(Long locataireId) {
        return contratLocationDAO.findByLocataire(locataireId);
    }

    @Override
    public List<ContratLocation> obtenirParUnite(Long uniteId) {
        return contratLocationDAO.findByUnite(uniteId);
    }

    @Override
    public List<ContratLocation> obtenirActifs() {
        return contratLocationDAO.findAllActive();
    }

    @Override
    public List<ContratLocation> obtenirExpirantDansJours(int jours) {
        return contratLocationDAO.findExpiringInDays(jours);
    }

    @Override
    public boolean mettreAJourStatut(Long contratId, ContratLocation.Statut statut) {
        // Récupérer le contrat pour gérer les changements d'état de l'unité
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(contratId);
        if (!optContrat.isPresent()) {
            return false;
        }

        ContratLocation contrat = optContrat.get();
        ContratLocation.Statut ancienStatut = contrat.getStatut();

        // Mettre à jour le statut du contrat
        boolean success = contratLocationDAO.updateStatut(contratId, statut);

        // Si la mise à jour a réussi, gérer le statut de l'unité
        if (success && contrat.getUnite() != null && ancienStatut != statut) {
            UniteLocation unite = contrat.getUnite();

            if (statut == ContratLocation.Statut.EN_COURS) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.LOUE);

                // NOUVEAU: Générer les paiements si le contrat passe en cours
                try {
                    System.out.println("DEBUG: Contrat activé via mettreAJourStatut - Génération des paiements pour le contrat " + contratId);
                    // Récupérer le contrat mis à jour avec le nouveau statut
                    Optional<ContratLocation> optContratMisAJour = contratLocationDAO.findById(contratId);
                    if (optContratMisAJour.isPresent()) {
                        paiementService.genererPaiementsMensuels(optContratMisAJour.get());
                        System.out.println("DEBUG: Paiements générés suite à l'activation du contrat " + contratId);
                    }
                } catch (Exception e) {
                    System.err.println("ERREUR lors de la génération des paiements suite à l'activation : " + e.getMessage());
                    // Ne pas faire échouer la mise à jour du statut
                }
            } else if (statut == ContratLocation.Statut.RESILIE ||
                    statut == ContratLocation.Statut.TERMINE) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.DISPONIBLE);
            } else if (statut == ContratLocation.Statut.EN_ATTENTE) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.RESERVE);
            }
        }

        return success;
    }

    @Override
    public ContratLocation renouveler(Long contratId, Date nouvelleDateFin, BigDecimal nouveauLoyer) throws Exception {
        // Récupérer le contrat
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(contratId);
        if (!optContrat.isPresent()) {
            throw new Exception("Contrat de location non trouvé.");
        }

        ContratLocation contrat = optContrat.get();

        // Vérifier si le contrat est en cours
        if (contrat.getStatut() != ContratLocation.Statut.EN_COURS) {
            throw new Exception("Seuls les contrats en cours peuvent être renouvelés.");
        }

        // Vérifier si la nouvelle date de fin est postérieure à la date de fin actuelle
        if (nouvelleDateFin.before(contrat.getDateFin())) {
            throw new Exception("La nouvelle date de fin doit être postérieure à la date de fin actuelle.");
        }

        // Sauvegarder l'ancienne date de fin pour la génération des paiements
        Date ancienneDateFin = contrat.getDateFin();

        // Mettre à jour la date de fin
        contrat.setDateFin(nouvelleDateFin);

        // Mettre à jour le loyer si spécifié
        if (nouveauLoyer != null && nouveauLoyer.compareTo(BigDecimal.ZERO) > 0) {
            contrat.setLoyer(nouveauLoyer);
        }

        // Mettre à jour la date de modification
        contrat.setDateModification(new Date());

        // Mettre à jour le contrat
        ContratLocation contratRenouvele = contratLocationDAO.update(contrat);

        // NOUVEAU: Générer les paiements pour la période de renouvellement
        try {
            System.out.println("DEBUG: Renouvellement du contrat " + contratId + " - Génération des paiements supplémentaires");

            // Créer un contrat temporaire avec les nouvelles données pour générer les paiements de la période étendue
            Calendar cal = Calendar.getInstance();
            cal.setTime(ancienneDateFin);
            cal.add(Calendar.MONTH, 1); // Commencer au mois suivant l'ancienne date de fin

            Date dateDebut = cal.getTime();
            Date dateFin = nouvelleDateFin;

            if (dateDebut.before(dateFin)) {
                // Générer les paiements pour la période étendue
                genererPaiementsPourPeriode(contratRenouvele, dateDebut, dateFin);
                System.out.println("DEBUG: Paiements de renouvellement générés pour le contrat " + contratId);
            }
        } catch (Exception e) {
            System.err.println("ERREUR lors de la génération des paiements de renouvellement : " + e.getMessage());
            // Ne pas faire échouer le renouvellement pour autant
        }

        // Envoyer la notification de renouvellement
        try {
            emailService.envoyerNotificationRenouvellement(contratRenouvele);
        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi de la notification de renouvellement : " + e.getMessage());
            // Ne pas faire échouer le renouvellement si l'email échoue
        }

        return contratRenouvele;
    }

    @Override
    public boolean resilier(Long contratId, Date dateResiliation, String motif, String commentaire) {
        // Récupérer le contrat
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(contratId);
        if (!optContrat.isPresent()) {
            return false;
        }

        ContratLocation contrat = optContrat.get();

        // Vérifier si le contrat est en cours
        if (contrat.getStatut() != ContratLocation.Statut.EN_COURS) {
            return false;
        }

        // Vérifier que la date de résiliation n'est pas antérieure à aujourd'hui
        Date today = new Date();
        if (dateResiliation.before(today)) {
            return false;
        }

        // Mettre à jour la date de fin et le statut
        contrat.setDateFin(dateResiliation);
        contrat.setStatut(ContratLocation.Statut.RESILIE);
        contrat.setDateModification(new Date());

        try {
            contratLocationDAO.update(contrat);

            // Mettre à jour le statut de l'unité
            UniteLocation unite = contrat.getUnite();
            if (unite != null) {
                uniteLocationDAO.updateStatut(unite.getId(), UniteLocation.Statut.DISPONIBLE);
            }

            // Envoyer la notification de résiliation
            try {
                emailService.envoyerNotificationResiliation(contrat, motif, commentaire);
            } catch (Exception e) {
                System.err.println("Erreur lors de l'envoi de la notification de résiliation : " + e.getMessage());
                // Ne pas faire échouer la résiliation si l'email échoue
            }

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public List<Paiement> genererPaiements(Long contratId, Date dateDebut, Date dateFin) throws Exception {
        // Récupérer le contrat
        Optional<ContratLocation> optContrat = contratLocationDAO.findById(contratId);
        if (!optContrat.isPresent()) {
            throw new Exception("Contrat de location non trouvé.");
        }

        ContratLocation contrat = optContrat.get();

        // Vérifier si le contrat est en cours ou en attente
        if (contrat.getStatut() != ContratLocation.Statut.EN_COURS &&
                contrat.getStatut() != ContratLocation.Statut.EN_ATTENTE) {
            throw new Exception("Seuls les paiements pour les contrats en cours ou en attente peuvent être générés.");
        }

        // Vérifier si les dates sont valides
        if (dateDebut.after(dateFin)) {
            throw new Exception("La date de début doit être antérieure à la date de fin.");
        }

        // Vérifier si les dates sont dans la période du contrat
        if (dateDebut.before(contrat.getDateDebut()) || dateFin.after(contrat.getDateFin())) {
            throw new Exception("Les dates doivent être dans la période du contrat.");
        }

        return genererPaiementsPourPeriode(contrat, dateDebut, dateFin);
    }

    /**
     * Méthode utilitaire pour générer les paiements pour une période donnée
     */
    private List<Paiement> genererPaiementsPourPeriode(ContratLocation contrat, Date dateDebut, Date dateFin) throws Exception {
        List<Paiement> paiements = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        cal.setTime(dateDebut);

        // Définir le jour du mois pour les paiements
        int jourPaiement = contrat.getJourPaiement();
        if (jourPaiement == 0) {
            jourPaiement = 5; // Par défaut le 5 du mois
        }

        // Générer les paiements mensuels
        while (cal.getTime().before(dateFin) || cal.getTime().equals(dateFin)) {
            // Vérifier si un paiement existe déjà pour ce mois
            List<Paiement> paiementsExistants = paiementDAO.findByContrat(contrat.getId());

            Calendar echeanceCal = Calendar.getInstance();
            echeanceCal.setTime(cal.getTime());
            int maxDayOfMonth = echeanceCal.getActualMaximum(Calendar.DAY_OF_MONTH);
            int dayToSet = Math.min(jourPaiement, maxDayOfMonth);
            echeanceCal.set(Calendar.DAY_OF_MONTH, dayToSet);

            // Vérifier s'il existe déjà un paiement pour ce mois
            final Date echeanceFinale = echeanceCal.getTime();
            boolean paiementExiste = paiementsExistants.stream()
                    .anyMatch(p -> {
                        Calendar existingCal = Calendar.getInstance();
                        existingCal.setTime(p.getDateEcheance());
                        Calendar newCal = Calendar.getInstance();
                        newCal.setTime(echeanceFinale);
                        return existingCal.get(Calendar.MONTH) == newCal.get(Calendar.MONTH) &&
                                existingCal.get(Calendar.YEAR) == newCal.get(Calendar.YEAR);
                    });

            if (!paiementExiste) {
                // Créer un nouveau paiement
                Paiement paiement = new Paiement();
                paiement.setContrat(contrat);

                // Calculer le montant total (loyer uniquement, les charges sont optionnelles)
                BigDecimal montantTotal = contrat.getLoyer();
                if (contrat.getChargesMensuelles() != null) {
                    montantTotal = montantTotal.add(contrat.getChargesMensuelles());
                }
                paiement.setMontant(montantTotal);

                paiement.setDateEcheance(echeanceFinale);
                paiement.setTypePaiement("LOYER");

                // Générer un numéro de référence unique
                paiement.setNumeroReference("PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

                // Définir le statut initial selon la date
                Date aujourdhui = new Date();
                if (echeanceFinale.before(aujourdhui)) {
                    paiement.setStatut(Paiement.Statut.EN_RETARD);
                } else {
                    paiement.setStatut(Paiement.Statut.EN_ATTENTE);
                }
                paiement.setDateCreation(new Date());

                // Persister le paiement
                try {
                    Paiement savedPaiement = paiementDAO.create(paiement);
                    paiements.add(savedPaiement);
                    System.out.println("DEBUG: Paiement créé - ID: " + savedPaiement.getId() +
                            ", Échéance: " + paiement.getDateEcheance() +
                            ", Statut: " + paiement.getStatut());
                } catch (Exception e) {
                    throw new Exception("Erreur lors de la création du paiement : " + e.getMessage());
                }
            }

            // Passer au mois suivant
            cal.add(Calendar.MONTH, 1);
        }

        return paiements;
    }

    @Override
    public List<ContratLocation> rechercher(Long locataireId, Long uniteId,
                                            ContratLocation.Statut statut,
                                            Date dateDebutMin, Date dateFinMax) {
        return contratLocationDAO.searchByCriteria(locataireId, uniteId, statut, dateDebutMin, dateFinMax);
    }

    /**
     * Méthode utilitaire pour valider les données d'un contrat.
     * @param contrat Le contrat à valider
     * @throws Exception Si les données sont invalides
     */
    private void validerContrat(ContratLocation contrat) throws Exception {
        if (contrat.getDateDebut() == null) {
            throw new Exception("La date de début du contrat est obligatoire.");
        }

        if (contrat.getDateFin() == null) {
            throw new Exception("La date de fin du contrat est obligatoire.");
        }

        if (contrat.getDateDebut().after(contrat.getDateFin())) {
            throw new Exception("La date de début doit être antérieure à la date de fin.");
        }

        if (contrat.getLoyer() == null || contrat.getLoyer().compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Le loyer doit être supérieur à zéro.");
        }

        if (contrat.getJourPaiement() < 1 || contrat.getJourPaiement() > 31) {
            throw new Exception("Le jour de paiement doit être compris entre 1 et 31.");
        }
    }
}