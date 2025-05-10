<template>
  <div class="whatsapp-templates">
    <div class="template-header">
      {{ $t('WHATSAPP_TEMPLATES.TITLE') }}
    </div>
    
    <div class="template-list" v-if="templates.length">
      <template-item
        v-for="template in templates"
        :key="template.id"
        :template="template"
        @select="onSelect"
      />
    </div>

    <div v-else class="empty-state">
      {{ $t('WHATSAPP_TEMPLATES.EMPTY') }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    templates: {
      type: Array,
      default: () => []
    }
  },

  methods: {
    formatTemplatePreview(template) {
      // Format template preview text
      return template.components
        .find(c => c.type === 'BODY')
        ?.text.replace(/{{[0-9]}}/g, '___');
    },

    onSelect(template) {
      this.$emit('select', template);
    }
  }
}
</script>
