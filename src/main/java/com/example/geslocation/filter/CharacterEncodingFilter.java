package com.example.geslocation.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filtre pour forcer l'encodage UTF-8 sur toutes les requêtes et réponses.
 */
public class CharacterEncodingFilter implements Filter {

    private String encoding;

    @Override
    public void init(FilterConfig config) throws ServletException {
        encoding = config.getInitParameter("encoding");
        if (encoding == null) {
            encoding = "UTF-8";
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Forcer l'encodage UTF-8 pour la requête
        httpRequest.setCharacterEncoding(encoding);

        // Forcer l'encodage UTF-8 pour la réponse
        httpResponse.setCharacterEncoding(encoding);
        httpResponse.setContentType("text/html; charset=" + encoding);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup si nécessaire
    }
}