-- =========================================
-- EXTENSÃO NECESSÁRIA PARA UUID
-- =========================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================================
-- TABELAS PRINCIPAIS
-- =========================================

-- Academias
CREATE TABLE IF NOT EXISTS academies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  cnpj VARCHAR(14) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  business_hours_open TIME,
  business_hours_close TIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Unidades físicas
CREATE TABLE IF NOT EXISTS academy_branches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  academy_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(255),
  business_hours_open TIME,
  business_hours_close TIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Endereços das unidades
CREATE TABLE IF NOT EXISTS academy_address (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  branch_id UUID NOT NULL,
  street VARCHAR(255),
  number VARCHAR(100),
  complement VARCHAR(255),
  neighborhood VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  postal_code VARCHAR(20)
);

-- Usuários
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('ADMIN', 'INSTRUCTOR', 'MEMBER')),
  name VARCHAR(255) NOT NULL,
  cpf VARCHAR(11) NOT NULL UNIQUE,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  birth_date DATE,
  academy_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  address_street VARCHAR(255),
  address_number VARCHAR(100),
  address_complement VARCHAR(255),
  address_neighborhood VARCHAR(255),
  address_city VARCHAR(255),
  address_state VARCHAR(255),
  address_postal_code VARCHAR(20),

  admin_permissions JSONB,
  instructor_specialty VARCHAR(100),
  instructor_hire_date DATE,
  member_medical_restrictions TEXT,
  member_emergency_contact VARCHAR(255)
);

-- Planos
CREATE TABLE IF NOT EXISTS plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  academy_id UUID NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  duration_days INTEGER NOT NULL,
  plan_type VARCHAR(100) NOT NULL,
  allows_guest BOOLEAN DEFAULT false,
  allowed_branches JSONB,
  max_daily_checkins INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Modalidades
CREATE TABLE IF NOT EXISTS modalities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  academy_id UUID NOT NULL,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('INDIVIDUAL', 'GROUP')),
  requires_plan BOOLEAN DEFAULT true,
  allows_dropin BOOLEAN DEFAULT false,
  dropin_price DECIMAL(10,2),
  max_capacity INTEGER,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relação Planos x Modalidades
CREATE TABLE IF NOT EXISTS plan_modalities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL,
  modality_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Matrículas
CREATE TABLE IF NOT EXISTS enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  plan_id UUID NOT NULL,
  academy_id UUID NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'CANCELLED')),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  guest_user_id UUID,
  guest_name VARCHAR(255),
  guest_identification VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_dates CHECK (end_date > start_date),
  CONSTRAINT chk_guest_data CHECK (
      (guest_user_id IS NULL AND guest_name IS NULL AND guest_identification IS NULL) OR
      (guest_user_id IS NOT NULL AND guest_name IS NULL AND guest_identification IS NULL) OR
      (guest_user_id IS NULL AND guest_name IS NOT NULL AND guest_identification IS NOT NULL)
    )
);

-- Aulas coletivas
CREATE TABLE IF NOT EXISTS group_classes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  modality_id UUID NOT NULL,
  branch_id UUID NOT NULL,
  instructor_id UUID,
  class_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  recurrence_pattern VARCHAR(50),
  current_enrollment INTEGER DEFAULT 0,
  status VARCHAR(20) DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED', 'CANCELLED', 'COMPLETED')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CHECK (end_time > start_time)
);

-- Inscrições em aulas
CREATE TABLE IF NOT EXISTS class_enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id UUID NOT NULL,
  user_id UUID NOT NULL,
  enrollment_type VARCHAR(20) NOT NULL CHECK (enrollment_type IN ('PLAN', 'DROPIN', 'GUEST')),
  payment_status VARCHAR(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID', 'CANCELLED')),
  paid_amount DECIMAL(10,2),
  status VARCHAR(20) DEFAULT 'REGISTERED' CHECK (status IN ('REGISTERED', 'CANCELLED', 'ATTENDED', 'ABSENT')),
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cancelled_at TIMESTAMP
);

-- Check-ins
CREATE TABLE IF NOT EXISTS checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  enrollment_id UUID NOT NULL,
  branch_id UUID NOT NULL,
  modality_id UUID NOT NULL,
  checkin_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  checkout_time TIMESTAMP,
  class_session_id UUID
);

-- =========================================
-- CONSTRAINTS DE FKS
-- =========================================

ALTER TABLE academy_branches
  ADD CONSTRAINT fk_branches_academy FOREIGN KEY (academy_id) REFERENCES academies(id);

ALTER TABLE academy_address
  ADD CONSTRAINT fk_address_branches_academy FOREIGN KEY (branch_id) REFERENCES academy_branches(id);

ALTER TABLE users
  ADD CONSTRAINT fk_user_academy FOREIGN KEY (academy_id) REFERENCES academies(id);

ALTER TABLE plans
  ADD CONSTRAINT fk_plans_academy FOREIGN KEY (academy_id) REFERENCES academies(id);

ALTER TABLE modalities
  ADD CONSTRAINT fk_modalities_academy FOREIGN KEY (academy_id) REFERENCES academies(id);

ALTER TABLE plan_modalities
  ADD CONSTRAINT fk_plan_modalities_plan FOREIGN KEY (plan_id) REFERENCES plans(id),
  ADD CONSTRAINT fk_plan_modalities_modality FOREIGN KEY (modality_id) REFERENCES modalities(id);

ALTER TABLE enrollments
  ADD CONSTRAINT fk_enrollments_user FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_enrollments_plan FOREIGN KEY (plan_id) REFERENCES plans(id),
  ADD CONSTRAINT fk_enrollments_academy FOREIGN KEY (academy_id) REFERENCES academies(id);

ALTER TABLE group_classes
  ADD CONSTRAINT fk_group_classes_modality FOREIGN KEY (modality_id) REFERENCES modalities(id),
  ADD CONSTRAINT fk_group_classes_branch FOREIGN KEY (branch_id) REFERENCES academy_branches(id),
  ADD CONSTRAINT fk_group_classes_instructor FOREIGN KEY (instructor_id) REFERENCES users(id);

ALTER TABLE class_enrollments
  ADD CONSTRAINT fk_class_enrollments_class FOREIGN KEY (class_id) REFERENCES group_classes(id),
  ADD CONSTRAINT fk_class_enrollments_user FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE checkins
  ADD CONSTRAINT fk_checkins_user FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT fk_checkins_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(id),
  ADD CONSTRAINT fk_checkins_branch FOREIGN KEY (branch_id) REFERENCES academy_branches(id),
  ADD CONSTRAINT fk_checkins_modality FOREIGN KEY (modality_id) REFERENCES modalities(id);

-- =========================================
-- CONSTRAINTS ESPECÍFICAS POR TIPO
-- =========================================
ALTER TABLE users ADD CONSTRAINT chk_admin_fields
  CHECK (user_type != 'ADMIN' OR (
    admin_permissions IS NOT NULL
    AND instructor_specialty IS NULL
    AND member_emergency_contact IS NULL
  ));

ALTER TABLE users ADD CONSTRAINT chk_instructor_fields
  CHECK (user_type != 'INSTRUCTOR' OR (
    instructor_specialty IS NOT NULL
    AND instructor_hire_date IS NOT NULL
    AND admin_permissions IS NULL
    AND member_emergency_contact IS NULL
  ));

ALTER TABLE users ADD CONSTRAINT chk_member_fields
  CHECK (user_type != 'MEMBER' OR (
    member_emergency_contact IS NOT NULL
    AND admin_permissions IS NULL
    AND instructor_specialty IS NULL
  ));

ALTER TABLE plans ADD CONSTRAINT chk_plans_positive_price
  CHECK (price >= 0);

ALTER TABLE plans ADD CONSTRAINT chk_plans_duration
  CHECK (duration_days > 0);

ALTER TABLE modalities ADD CONSTRAINT chk_max_capacity_per_type
  CHECK (type != 'GROUP' OR max_capacity IS NULL OR max_capacity > 0);

ALTER TABLE modalities ADD CONSTRAINT chk_modality_positive_dropin_price
  CHECK (dropin_price >= 0 OR dropin_price IS NULL);

ALTER TABLE plan_modalities ADD CONSTRAINT uk_plan_modalities_unique
    UNIQUE (plan_id, modality_id);

ALTER TABLE class_enrollments ADD CONSTRAINT uk_class_enrollments_unique
    UNIQUE (class_id, user_id);

-- =========================================
-- ÍNDICES PARA PERFORMANCE
-- =========================================

-- Academies
CREATE INDEX IF NOT EXISTS idx_academies_cnpj ON academies(cnpj);

-- Branches
CREATE INDEX IF NOT EXISTS idx_branches_academy ON academy_branches(academy_id);
CREATE INDEX IF NOT EXISTS idx_address_branch ON academy_address(branch_id);

-- Users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_academy ON users(academy_id);
CREATE INDEX IF NOT EXISTS idx_users_type ON users(user_type);

-- Plans
CREATE INDEX IF NOT EXISTS idx_plans_academy ON plans(academy_id);
CREATE INDEX IF NOT EXISTS idx_plans_active ON plans(is_active);

-- Modalities
CREATE INDEX IF NOT EXISTS idx_modalities_academy ON modalities(academy_id);
CREATE INDEX IF NOT EXISTS idx_modalities_type ON modalities(type);
CREATE INDEX IF NOT EXISTS idx_modalities_active ON modalities(is_active);

-- Plan Modalities
CREATE INDEX IF NOT EXISTS idx_plan_modalities_plan ON plan_modalities(plan_id);
CREATE INDEX IF NOT EXISTS idx_plan_modalities_modality ON plan_modalities(modality_id);

-- Enrollments
CREATE INDEX IF NOT EXISTS idx_enrollments_user ON enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_plan ON enrollments(plan_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON enrollments(status);

-- Enrollments: apenas 1 ACTIVE por user
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_single_active_plan
ON enrollments(user_id)
WHERE status = 'ACTIVE';

-- Group Classes
CREATE INDEX IF NOT EXISTS idx_group_classes_modality ON group_classes(modality_id);
CREATE INDEX IF NOT EXISTS idx_group_classes_branch ON group_classes(branch_id);
CREATE INDEX IF NOT EXISTS idx_group_classes_date ON group_classes(class_date);
CREATE INDEX IF NOT EXISTS idx_group_classes_instructor ON group_classes(instructor_id);

-- Class Enrollments
CREATE INDEX IF NOT EXISTS idx_class_enrollments_class ON class_enrollments(class_id);
CREATE INDEX IF NOT EXISTS idx_class_enrollments_user ON class_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_class_enrollments_payment ON class_enrollments(payment_status);

-- Checkins
CREATE INDEX IF NOT EXISTS idx_checkins_user ON checkins(user_id);
CREATE INDEX IF NOT EXISTS idx_checkins_enrollment ON checkins(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_checkins_branch ON checkins(branch_id);
CREATE INDEX IF NOT EXISTS idx_checkins_time ON checkins(checkin_time);

-- =========================================
-- COMENTÁRIOS
-- =========================================

COMMENT ON TABLE academies IS 'Tabela de academias cadastradas no sistema';
COMMENT ON COLUMN academies.cnpj IS 'CNPJ único para cada academia';

COMMENT ON TABLE academy_address IS 'Endereços das unidades das academias';

COMMENT ON TABLE users IS 'Usuários do sistema (Administradores, Instrutores, Membros)';

COMMENT ON TABLE modalities IS 'Modalidades oferecidas pelas academias';
COMMENT ON COLUMN modalities.requires_plan IS 'Se precisa de plano vigente para acessar';
COMMENT ON COLUMN modalities.allows_dropin IS 'Se permite aula avulsa sem plano';

COMMENT ON TABLE plans IS 'Planos oferecidos pelas academias';
COMMENT ON COLUMN plans.allows_guest IS 'Se permite convidado (VC + Amigo)';
COMMENT ON COLUMN plans.allowed_branches IS 'Unidades permitidas (NULL = todas)';

COMMENT ON TABLE plan_modalities IS 'Relação entre planos e modalidades permitidas (muitos-para-muitos)';

COMMENT ON TABLE enrollments IS 'Matrículas dos usuários em planos';
COMMENT ON COLUMN enrollments.guest_user_id IS 'Convidado como usuário do sistema';
COMMENT ON COLUMN enrollments.guest_name IS 'Nome do convidado externo';

COMMENT ON TABLE group_classes IS 'Sessões específicas de aulas coletivas';
COMMENT ON COLUMN group_classes.recurrence_pattern IS 'Padrão de recorrência (DAILY, WEEKLY, etc)';

COMMENT ON TABLE class_enrollments IS 'Inscrições em aulas coletivas específicas';
COMMENT ON COLUMN class_enrollments.enrollment_type IS 'Tipo de inscrição (PLAN=incluso, DROPIN=avulsa)';

COMMENT ON TABLE checkins IS 'Registro de frequência dos usuários';
COMMENT ON COLUMN checkins.class_session_id IS 'Aula coletiva específica (se aplicável)';
