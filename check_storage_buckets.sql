-- ============================================
-- VERIFICAR BUCKETS DE STORAGE EN SUPABASE
-- ============================================

-- Ver todos los buckets existentes
SELECT 
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types,
    created_at,
    updated_at
FROM storage.buckets
ORDER BY created_at DESC;

-- Verificar si existe el bucket 'event-media' específicamente
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM storage.buckets WHERE id = 'event-media') 
        THEN '✅ Bucket "event-media" existe'
        ELSE '❌ Bucket "event-media" NO existe'
    END AS status;

-- Ver políticas RLS de un bucket específico (ejemplo: event-media)
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'storage' 
  AND tablename = 'objects'
  AND policyname LIKE '%event-media%' OR policyname LIKE '%event_media%';

-- Ver todos los buckets y sus políticas
SELECT 
    b.id AS bucket_id,
    b.name AS bucket_name,
    b.public AS is_public,
    COUNT(DISTINCT p.policyname) AS policy_count
FROM storage.buckets b
LEFT JOIN pg_policies p ON p.schemaname = 'storage' 
    AND p.tablename = 'objects'
    AND (p.policyname LIKE '%' || b.id || '%')
GROUP BY b.id, b.name, b.public
ORDER BY b.created_at DESC;
