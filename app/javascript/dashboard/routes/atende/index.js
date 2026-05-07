import { frontendURL } from '../../helper/URLHelper';

const AtendeWrapper = () => import('./components/AtendeWrapper.vue');
const FlowList = () => import('./flows/List.vue');
const FlowBuilder = () => import('./flows/Builder.vue');
const AgentList = () => import('./agents/List.vue');
const AgentEditor = () => import('./agents/Editor.vue');
const Playground = () => import('./agents/Playground.vue');
const SessionList = () => import('./sessions/List.vue');
const AccountVariables = () => import('./settings/AccountVariables.vue');

export const routes = [
  {
    path: frontendURL('accounts/:accountId/bots-ia'),
    component: AtendeWrapper,
    children: [
      {
        path: 'flows',
        name: 'atende_flows',
        component: FlowList,
        meta: { permissions: ['administrator', 'agent'] },
      },
      {
        path: 'flows/:flowId/edit',
        name: 'atende_flow_edit',
        component: FlowBuilder,
        meta: { permissions: ['administrator'] },
      },
      {
        path: 'agents',
        name: 'atende_agents',
        component: AgentList,
        meta: { permissions: ['administrator'] },
      },
      {
        path: 'agents/:agentId/edit',
        name: 'atende_agent_edit',
        component: AgentEditor,
        meta: { permissions: ['administrator'] },
      },
      {
        path: 'agents/:agentId/playground',
        name: 'atende_agent_playground',
        component: Playground,
        meta: { permissions: ['administrator'] },
      },
      {
        path: 'sessions',
        name: 'atende_sessions',
        component: SessionList,
        meta: { permissions: ['administrator', 'agent'] },
      },
      {
        path: 'settings/variables',
        name: 'atende_variables',
        component: AccountVariables,
        meta: { permissions: ['administrator'] },
      },
    ],
  },
];
