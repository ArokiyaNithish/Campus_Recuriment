package com.campus.recruitment.portal.repository;

import com.campus.recruitment.portal.model.AssessmentQuestion;
import com.campus.recruitment.portal.model.Job;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssessmentQuestionRepository extends JpaRepository<AssessmentQuestion, Long> {
    List<AssessmentQuestion> findByJob(Job job);
    long countByJob(Job job);
    void deleteByJob(Job job);
}
