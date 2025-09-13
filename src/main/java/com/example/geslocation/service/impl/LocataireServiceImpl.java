package com.example.geslocation.service.impl;

import com.example.geslocation.dao.LocataireDAO;
import com.example.geslocation.dao.UtilisateurDAO;
import com.example.geslocation.dao.impl.LocataireDAOImpl;
import com.example.geslocation.dao.impl.UtilisateurDAOImpl;
import com.example.geslocation.model.Locataire;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.service.LocataireService;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation du service pour les opérations liées aux locataires.
 */
public class LocataireServiceImpl implements LocataireService {
    
    private final LocataireDAO locataireDAO;
    private final UtilisateurDAO utilisateurDAO;
    
    // Ratio de revenu/loyer recommandé (le loyer ne devrait pas dépasser 30% du revenu)
    private static final double RATIO_REVENU_LOYER = 0.3;
    
    /**
     * Constructeur par défaut qui initialise les DAOs.
     */
    public LocataireServiceImpl() {
        this.locataireDAO = new LocataireDAOImpl();
        this.utilisateurDAO = new UtilisateurDAOImpl();
    }
    
    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param locataireDAO Le DAO des locataires
     * @param utilisateurDAO Le DAO des utilisateurs
     */
    public LocataireServiceImpl(LocataireDAO locataireDAO, UtilisateurDAO utilisateurDAO) {
        this.locataireDAO = locataireDAO;
        this.utilisateurDAO = utilisateurDAO;
    }
    
    @Override
    public Locataire creer(Locataire locataire, Utilisateur utilisateur) throws Exception {
        // Vérifier si l'email est déjà utilisé
        Optional<Utilisateur> existingUser = utilisateurDAO.findByEmail(utilisateur.getEmail());
        if (existingUser.isPresent()) {
            throw new Exception("Un utilisateur avec cet email existe déjà.");
        }
        
        // Définir le rôle LOCATAIRE pour l'utilisateur
        utilisateur.setRole(Utilisateur.Role.LOCATAIRE);
        utilisateur.setDateCreation(new Date());
        
        // Définir la date de création pour le locataire
        locataire.setDateCreation(new Date());
        
        // Créer le locataire avec l'utilisateur
        return locataireDAO.createWithUtilisateur(locataire, utilisateur);
    }
    
    @Override
    public Locataire creerAvecUtilisateurExistant(Locataire locataire, Long utilisateurId) throws Exception {
        // Vérifier si l'utilisateur existe
        Optional<Utilisateur> optUtilisateur = utilisateurDAO.findById(utilisateurId);
        if (!optUtilisateur.isPresent()) {
            throw new Exception("Utilisateur non trouvé.");
        }
        
        Utilisateur utilisateur = optUtilisateur.get();
        
        // Vérifier si l'utilisateur a déjà un profil locataire
        Optional<Locataire> existingLocataire = locataireDAO.findByUtilisateur(utilisateurId);
        if (existingLocataire.isPresent()) {
            throw new Exception("Cet utilisateur a déjà un profil locataire.");
        }
        
        // Mettre à jour le rôle de l'utilisateur si nécessaire
        if (utilisateur.getRole() != Utilisateur.Role.LOCATAIRE) {
            utilisateur.setRole(Utilisateur.Role.LOCATAIRE);
            utilisateurDAO.update(utilisateur);
        }
        
        // Définir l'utilisateur et la date de création
        locataire.setUtilisateur(utilisateur);
        locataire.setDateCreation(new Date());
        
        // Persister le locataire
        return locataireDAO.create(locataire);
    }
    
    @Override
    public Optional<Locataire> obtenirParId(Long id) {
        return locataireDAO.findById(id);
    }
    
    @Override
    public Optional<Locataire> obtenirParUtilisateur(Long utilisateurId) {
        return locataireDAO.findByUtilisateur(utilisateurId);
    }
    
    @Override
    public Optional<Locataire> obtenirParEmail(String email) {
        return locataireDAO.findByEmail(email);
    }
    
    @Override
    public Locataire mettreAJour(Locataire locataire) throws Exception {
        // Vérifier si le locataire existe
        Optional<Locataire> optLocataire = locataireDAO.findById(locataire.getId());
        if (!optLocataire.isPresent()) {
            throw new Exception("Locataire non trouvé.");
        }
        
        // Conserver l'utilisateur et la date de création
        Locataire existingLocataire = optLocataire.get();
        locataire.setUtilisateur(existingLocataire.getUtilisateur());
        locataire.setDateCreation(existingLocataire.getDateCreation());
        
        // Mettre à jour la date de modification
        locataire.setDateModification(new Date());
        
        // Mettre à jour le locataire
        return locataireDAO.update(locataire);
    }
    
    @Override
    public boolean supprimer(Long id) {
        return locataireDAO.delete(id);
    }
    
    @Override
    public List<Locataire> obtenirTous() {
        return locataireDAO.findAll();
    }
    
    @Override
    public List<Locataire> obtenirParRevenuMin(Double revenuMin) {
        return locataireDAO.findByRevenuMin(revenuMin);
    }
    
    @Override
    public List<Locataire> rechercher(String nom, String prenom, Double revenuMin) {
        return locataireDAO.searchByCriteria(nom, prenom, revenuMin);
    }
    
    @Override
    public boolean estEligiblePourLocation(Long locataireId, Double loyerMensuel) {
        // Récupérer le locataire
        Optional<Locataire> optLocataire = locataireDAO.findById(locataireId);
        if (!optLocataire.isPresent() || loyerMensuel == null) {
            return false;
        }
        
        Locataire locataire = optLocataire.get();
        Double revenuMensuel = locataire.getRevenuMensuel();
        
        // Vérifier si le revenu est suffisant (le loyer ne devrait pas dépasser 30% du revenu)
        if (revenuMensuel == null) {
            return false;
        }
        
        return loyerMensuel <= (revenuMensuel * RATIO_REVENU_LOYER);
    }
}